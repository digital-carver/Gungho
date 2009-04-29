package Gungho::Agent;
use Moose;
use LWP::UserAgent;

with 'MooseX::Traits';

has agent => (
    is => 'ro',
    required => 1,
    lazy_build => 1
);

sub _build_agent {
    return LWP::UserAgent->new();
}

sub handle_request {
    my ($self, $req) = @_;

    eval {
        my $res = $self->fetch($req);
        $self->handle_response($res);
    };

    return ();
}

sub fetch {
    my ($self, $req) = @_;

    my $res;
    eval {
        $self->verify_request($req);
        $res = $self->agent->request($req);
    };
    if ($@) {
        $res = HTTP::Response->new(500, $@);
    }
    return $res;
}

sub verify_request {}

1;