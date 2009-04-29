
package Gungho::Test::Live::Simple;
use base 'Test::Class';
use Moose;
use namespace::clean -except => qw(meta);
use Test::More;

extends 'Gungho::Test';

sub setup_block_ip :Test(setup) {
    my $self = shift;
    $self->add_trait('Gungho::Trait::BlockPrivateIP');
}

sub private_127_X_X_X :Test {
    my $self = shift;
    my $res = $self->fetch(HTTP::Request->new(GET => 'http://127.0.0.1'));
    ok($res->is_error);
}

sub private_172_16_X_X :Tests(4) {
    my $self = shift;

    foreach my $host qw(172.16.1.1 172.31.1.1) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        ok($res->is_error);
    }
    foreach my $host qw(172.15.1.1 172.32.1.1) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        ok($res->is_success);
    }
}

sub private_192_168_X_X :Tests(2) {
    my $self = shift;
    foreach my $host qw(192.168.1.1 192.168.51.14) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        ok($res->is_error);
    }
}

1;
