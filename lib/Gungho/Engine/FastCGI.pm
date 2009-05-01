package Gungho::Engine::FastCGI;
use Moose::Role;
use FCGI;

with 'Gungho::Role::Engine';

has detach => (
    is => 'rw',
    isa => 'Bool',
);

has keep_stderr => (
    is => 'rw',
    isa => 'Bool',
);

has leave_umask => (
    is => 'rw',
    isa => 'Bool',
);

has listen => (
    is => 'rw',
    isa => 'Str', # Path::Class::File?
    predicate => 'has_listen',
);

has manager => (
    is => 'rw',
    isa => 'ClassName',
    default => 'FCGI::ProcManager'
);

has nointr => (
    is => 'rw',
    isa => 'Bool',
);

has nproc => (
    is => 'rw',
    isa => 'Int',
    default => 1
);

has pidfile => (
    is => 'rw',
    isa => 'Str', # Path::Class::File?
);

sub run {
    my $self = shift;

    my $sock = 0;
    if ($self->has_listen) {
        my $old_umask = umask;
        unless ( $self->leave_umask ) {
            umask(0);
        }
        $sock = FCGI::OpenSocket( $self->listen, 100 )
          or die "failed to open FastCGI socket; $!";
        unless ( $self->leave_umask ) {
            umask($old_umask);
        }
    }
    elsif ( $^O ne 'MSWin32' ) {
        -S STDIN
          or die "STDIN is not a socket; specify a listen location";
    }

    my %env;
    my $error = \*STDERR; # send STDERR to the web server
       $error = \*STDOUT  # send STDERR to stdout (a logfile)
         if $self->keep_stderr; # (if asked to)

    my $request =
      FCGI::Request( \*STDIN, \*STDOUT, $error, \%env, $sock,
        ( $self->nointr ? 0 : &FCGI::FAIL_ACCEPT_ON_INTR ),
      );

    my $proc_manager;

    if ($self->has_listen) {
        $self->daemon_fork() if $self->detach;

        if ( my $manager_class = $self->manager ) {
            Class::MOP::load_class($manager_class);

            $proc_manager = $manager_class->new(
                {
                    n_processes => $self->nproc,
                    pid_fname   => $self->pidfile,
                }
            );

            # detach *before* the ProcManager inits
            $self->daemon_detach() if $self->detach;

            $proc_manager->pm_manage();

            # Give each child its own RNG state.
            srand;
        }
        elsif ( $self->detach ) {
            $self->daemon_detach();
        }
    }

    while ( $request->Accept >= 0 ) {
        $proc_manager && $proc_manager->pm_pre_dispatch();

        $self->_fix_env( \%env );

        $self->handle_request( env => \%env );

        $proc_manager && $proc_manager->pm_post_dispatch();
    }

    return ();
}

1;