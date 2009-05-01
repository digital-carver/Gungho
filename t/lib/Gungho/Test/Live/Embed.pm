package Gungho::Test::Live::Embed;
use base 'Test::Class';
use Moose;
use namespace::clean -except => qw(meta);
use Test::More;

extends 'Gungho::Test';

sub setup_component :Test(setup) {
    my $self = shift;
    $self->add_trait('Gungho::Engine::Embed');
    $self->add_trait('Gungho::Trait::Log::Memory');
}

sub loop :Tests {
    my $self = shift;

    $self->agent->add_request(
        HTTP::Request->new(GET => 'http://www.perl.com'),
        HTTP::Request->new(GET => 'http://search.cpan.org'),
    );
    $self->agent->run();

    my @logs = $self->agent->all_logs;
    is($logs[0]->[1], 'http://www.perl.com');
    is($logs[1]->[1], 'http://search.cpan.org');
}

1;