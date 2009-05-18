package Gungho::Test::Core::RobotsMETA;
use Moose;
use MooseX::NonMoose;
use Test::More;
BEGIN { extends 'Test::FITesque::Fixture' }
use namespace::clean -except => qw(meta);

with 'Gungho::Test::Role::Basic';

after setup => sub {
    my $self = shift;
    $self->add_trait($_) for qw(
        Engine::Embed
        Trait::RobotsMETA
    );
};

sub parse :Test :Plan(4) {
    my ($self, $uri) = @_;

    $self->gungho->agent
        ->set_always( request => HTTP::Response->new(200, "OK", [ content_type => 'text/html' ], <<EOHTML) );

<HTML>
<HEAD>
    <META NAME="robots" CONTENT="FOLLOW,NOARCHIVE" />
</HEAD>
<BODY>
    <H1>dummy1</H1>
</BODY>
</HTML>

EOHTML
    my $res = $self->get($uri);

    my $meta = $res->notes_get('robots_meta');
    ok($meta);
    isa_ok($meta, 'HTML::RobotsMETA::Rules');
    ok($meta->can_follow);
    ok(! $meta->can_archive);
}

__PACKAGE__->meta->make_immutable;

1;

