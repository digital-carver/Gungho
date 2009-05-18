package Gungho::Test::Role::Basic;
use Moose::Role;
use parent 'Test::FITesque::Fixture';
use namespace::clean -except => qw(meta);
use HTTP::Request;
use Test::More;

with 'Gungho::Test::Fixture';

sub get {
    my ($self, $uri) = @_;
    my $res = $self->gungho->fetch(HTTP::Request->new(GET => $uri));
    return $res;
}

sub get_ok {
    my ($self, $uri) = @_;
    my $res  = $self->get($uri);
    my $ok   =  ok($res->is_success, "request is success" );
    if (!$ok) {
       note(explain($res));
    }
    return $ok;
};

sub get_error {
    my ($self, $uri) = @_;
    my $res  = $self->gungho->fetch(HTTP::Request->new(GET => $uri));
    my $ok   = ok($res->is_error, "request is error (expected)" );
    if (!$ok) {
         note(explain($res));
    }
    return $ok;
}
        
1;
