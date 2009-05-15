package Gungho::Test::Core::RobotRules;
use Moose;
use MooseX::NonMoose;
BEGIN { extends 'Test::FITesque::Fixture' }
use Test::More;
use Test::MockObject;
use LWP::UserAgent;

use namespace::clean -except => qw(meta);

with 'Gungho::Test::Fixture';

after setup => sub {
    my $self = shift;
    $self->add_trait($_) for qw(
        Engine::Embed
        Trait::RobotRules
    );
};

sub basic_robotrules :Test :Plan(3) {
    my ($self, %args) = @_;

    my $agent = $self->agent;
    local $agent->{agent} = 
        Test::MockObject::Extends->new( LWP::UserAgent->new() )
            ->mock( request => sub {
                my ($self, $request) = @_;

                if ($request->uri->path eq '/robots.txt') {
                    return HTTP::Response->new(200, "OK", undef, <<EOM);
User-Agent: *
Disallow: /disallowed
EOM
                } else {
                    return HTTP::Response->new(200, "OK", undef, "OK");
                }
            })
    ;

    {
        my $res = $self->fetch(HTTP::Request->new(GET => 'http://localhost'));
        ok ($res->is_success) or
            note(explain($res));
    }

    {
        my $res = $self->fetch(HTTP::Request->new(GET => 'http://localhost/disallowed'));
        ok ($res->is_error);
    }

    {
        my $res = $self->fetch(HTTP::Request->new(GET => 'http://localhost/allowed'));
        ok ($res->is_success);
    }
}
        

__PACKAGE__->meta->make_immutable;

