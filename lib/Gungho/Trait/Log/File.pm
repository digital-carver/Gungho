package Gungho::Trait::Log::File;
use Moose::Role;
use namespace::clean -except => qw(meta);
use MooseX::Types::Path::Class;

with 'Gungho::Trait::Log';

has file => (
    is => 'rw',
    isa => 'Path::Class::File',
    trigger => sub {
        $_[0]->clear_fh();
    }
);

has fh => (
    is => 'rw',
    isa => 'GlobRef',
    clearer => 'clear_fh',
    lazy    => 1,
    builder => '_open_file'
);

sub _open_file {
    my $self = shift;
    my $parent = $self->file->parent;
    if (! -d $parent) {
        $parent->mkpath;
    }

    my $fh = $self->file->openw;
    $fh->seek(0, 2);

    return $fh;
}

sub format_message {
    shift;
    return POSIX::strftime('[%Y-%m-%d %H:%M:%S] ') . "@_\n"
}

sub log {
    my $self = shift;
    my $fh   = $self->fh();

    print $fh $self->format_message(@_);
}


1;