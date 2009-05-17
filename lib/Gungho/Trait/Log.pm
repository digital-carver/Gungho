package Gungho::Trait::Log;
use Moose::Role;
use namespace::clean -except => qw(meta);

around fetch => sub {
    my ($next, $self, $req) = @_;

    my $res = $next->($self, $req);
    $self->log( $req->method, $req->uri, $res->code );
};

1;
