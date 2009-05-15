package Gungho::Test::Fixture;
use Moose::Role;
use MooseX::AttributeHelpers;
use namespace::clean -except => qw(meta);
use HTTP::Request;
use Test::MockObject::Extends;

has traits => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
    provides => {
        elements => 'all_traits',
        push => 'add_trait',
    }
);

has agent => (
    is => 'ro',
    isa => 'Gungho',
    lazy_build => 1,
    handles => [ 'fetch' ]
);

has agent_args => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
    provides => {
        elements => 'all_agent_args',
    }
);

sub setup { }
sub teardown { }

sub _build_agent_args { return [] }
sub _build_traits { [] }
sub _build_agent {
    my $self = shift;
    Class::MOP::load_class('Gungho');

    my @traits = $self->all_traits;
    my %traits;
    @traits{@traits} = 1;

    Gungho->new_with_traits(
        $self->all_agent_args,
        traits => [ keys %traits ]
    );
}

1;
