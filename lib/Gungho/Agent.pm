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
    LWP::UserAgent->new();
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