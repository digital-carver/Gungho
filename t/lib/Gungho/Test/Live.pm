
package Gungho::Test::Live;
use Moose;
use namespace::clean -except => qw(meta);
use Test::More;
use Test::MockObject;
use LWP::UserAgent;

BEGIN { extends 'Gungho::Test::Fixture' };

override _build_traits => sub {
    return [
        'Engine::Embed',
        'Trait::BlockPrivateIP',
#        'Trait::RobotRules'
    ]
};

sub _build_agent_args {
    return [
        agent  => Test::MockObject::Extends->new(
            LWP::UserAgent->new()
        )->set_always( request => HTTP::Response->new(200, "OK") )
    ]
}

sub search_cpan_org :Test {
    my $self = shift;
    my $res = $self->fetch(HTTP::Request->new(GET => 'http://search.cpan.org'));
    ok($res->is_success);
}

sub private_127_X_X_X :Test {
    my $self = shift;
    my $res = $self->fetch(HTTP::Request->new(GET => 'http://127.0.0.1'));
    ok($res->is_error);
}

sub private_172_16_X_X :Test :Plan(4) {
    my $self = shift;

    foreach my $host qw(172.16.1.1 172.31.1.1) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        if (! ok($res->is_error)) {
            note($res->as_string);
        }
    }
    foreach my $host qw(172.15.1.1 172.32.1.1) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        if (! ok($res->is_success)) {
            note($res->as_string);
        }
    }
}

sub private_192_168_X_X :Test :Plan(2) {
    my $self = shift;
    foreach my $host qw(192.168.1.1 192.168.51.14) {
        my $res = $self->fetch(HTTP::Request->new(GET => "http://$host"));
        ok($res->is_error);
    }
}

1;
