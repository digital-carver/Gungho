package Gungho::Agent;
use Moose;
use namespace::clean -except => qw(meta);
use LWP::UserAgent;
use Net::DNS;
use Regexp::Common qw(net);

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

my $IPADDRESS_RE = qr/^$RE{net}{IPv4}{-keep}$/;
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
    };
    if (my $e = $@) {
        $res = HTTP::Response->new(500, $e);
    }
    return $res;
}

sub verify_request {}
sub handle_response {}

sub prepare_request {
    my ($self, $req) = @_;

    my $host = $req->header('Host') || $req->uri->host;

    if ($host !~ /$IPADDRESS_RE/x) {
        my $query = $self->resolver->search($host);
        if ($query) {
            foreach my $rr ($query->answer) {
                next unless $rr->type eq "A";
                $req->header('X-Original-Host', $host);
                $req->header('Host', $host);
                $req->uri->host($rr->address);
                last;
            }
        } else {
            die("DNS lookup for $host failed: " . $self->resolver->errorstring);
        }
    }

    return ();
}

__PACKAGE__->meta->make_immutable;

1;