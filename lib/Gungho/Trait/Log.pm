package Gungho::Trait::Log;
use Moose::Role;

around fetch => sub {
    my ($next, $self, $req) = @_;

    my $res = $next->($self, $req);
    $self->log( $req->method, $req->uri, $res->code );
};

1;
