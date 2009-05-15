package Gungho::Test::Core::RobotRules;
use Moose;
use MooseX::NonMoose;
BEGIN { extends 'Test::FITesque::Fixture' }
use Test::MockObject;
use Test::More;
use Test::Exception;
use LWP::UserAgent;

use namespace::clean -except => qw(meta);

with 'Gungho::Test::Role::Basic';

after setup => sub {
    my $self = shift;
    $self->add_trait($_) for qw(
        Engine::Embed
        Trait::RobotRules
    );
};

sub basic_robotrules :Test :Plan(6) {
    my ($self, %args) = @_;

    $self->gungho->agent->mock(
        request => sub {
            my ($self, $request) = @_;
            if ($request->uri->path eq '/robots.txt') {
                return HTTP::Response->new(200, "OK", undef, <<EOM);
User-Agent: *
Disallow: /disallowed
EOM
            } else {
                return HTTP::Response->new(200, "OK", undef, "OK");
            }
        }
    );

    lives_ok {
        $self->get_ok('http://localhost');
        is( ($self->gungho->agent->call_args(1))[1]->uri, 'http://localhost/robots.txt');
        is( ($self->gungho->agent->call_args(2))[1]->uri, 'http://localhost');
        $self->get_error('http://localhost/disallowed');
        $self->get_ok('http://localhost/allowed');
    } "HTTP request lives_ok";
    $self->gungho->agent->unmock('_make_request');
}
        

__PACKAGE__->meta->make_immutable;

