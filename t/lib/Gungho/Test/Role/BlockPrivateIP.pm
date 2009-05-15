package Gungho::Test::Role::BlockPrivateIP;
use Moose::Role;
use parent 'Test::FITesque::Fixture';
use namespace::clean -except => qw(meta);
use Test::More;
use Test::MockObject;
use Test::Exception;
use LWP::UserAgent;

with 'Gungho::Test::Fixture';

after setup => sub {
    my $self = shift;
    $self->add_trait($_) for qw(
        Engine::Embed
        Trait::BlockPrivateIP
    );
};

around qw( private_127_X_X_X private_172_16_X_X private_192_168_X_X) => sub {
    my ($next, $self, @args) = @_;
    $self->gungho->agent->set_always(request => HTTP::Response->new(200));
    $next->($self, @args);
    $self->gungho->agent->unmock('request');
};

sub private_127_X_X_X :Test :Plan(2) {
    my $self = shift;
    lives_ok {
        $self->get_error('http://127.0.0.1');
    };
}

sub private_172_16_X_X :Test :Plan(5) {
    my $self = shift;

    lives_ok {
        foreach my $host qw(172.16.1.1 172.31.1.1) {
            $self->get_error("http://$host");
        }
        foreach my $host qw(172.15.1.1 172.32.1.1) {
            $self->get_ok("http://$host")
        }
    };
}

sub private_192_168_X_X :Test :Plan(3) {
    my $self = shift;
    lives_ok {
        foreach my $host qw(192.168.1.1 192.168.51.14) {
            $self->get_error("http://$host");
        }
    }
}

1;