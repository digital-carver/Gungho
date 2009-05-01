package Gungho::Agent;
use Moose;
use namespace::clean -except => qw(meta);
use LWP::UserAgent;
use Net::DNS;

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

sub _build_agent { return LWP::UserAgent->new() }
sub _build_resolver { return Net::DNS::Resolver->new }

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
    eval {
        $self->prepare_request($req);
        $self->verify_request($req);
        $res = $self->agent->request($req);
        $self->fixup_response($res);
    };
    if (my $e = $@) {
        $res = HTTP::Response->new(500, $e);
    }
    return $res;
}

sub verify_request {}
sub prepare_request {}
sub handle_response {}
sub fixup_response {}

__PACKAGE__->meta->make_immutable;

1;