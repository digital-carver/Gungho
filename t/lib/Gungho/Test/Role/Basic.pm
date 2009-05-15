package Gungho::Test::Role::Basic;
use Moose::Role;
use parent 'Test::FITesque::Fixture';
use namespace::clean -except => qw(meta);
use Test::More;

with 'Gungho::Test::Fixture';

sub fetch_ok :Test {
    my ($self, %args) = @_;
    my $res = $self->fetch(HTTP::Request->new(GET => $args{uri}));
    ok($res->is_success);
}

1;
