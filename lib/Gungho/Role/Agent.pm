package Gungho::Role::Agent;
use Moose::Role;
use Gungho::Exception;
use Gungho::Response;
use namespace::clean -except => qw(meta);

with 'MooseX::Traits';

has agent => (
    is => 'ro',
    required => 1,
    lazy_build => 1
);

has resolver => (
    is => 'ro',
    required => 1,
    lazy_build => 1
);

sub _build_agent {}

sub _build_resolver {}

sub handle_request {
    my ($self, $req) = @_;

    my $res = $self->fetch($req);
    $self->handle_response($res);

    return ();
}

sub fetch {
    my ($self, $req) = @_;

    my $res;
    local $@;

    GUNGHO_FETCH: {
        eval {
            $self->prepare_request($req);
            $self->verify_request($req);
            $res = $self->agent->request($req);

            # coerce this response object to our own object
            $res = Gungho::Response->new_from_response($res);

            $self->fixup_response($res);
        };
        if (my $e = $@){
            if (blessed $e && $e->isa('Gungho::Exception::RedoRequest')) {
                redo GUNGHO_FETCH;
            } else {
                $res = Gungho::Response->new(500, $e);
            }
        }
    }
    return $res;
}

sub verify_request {}
sub prepare_request {}
sub handle_response {}
sub fixup_response {}

1;
