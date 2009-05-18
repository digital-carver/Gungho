package Gungho::Test::Fixture;
use Moose::Role;
use MooseX::AttributeHelpers;
use namespace::clean -except => qw(meta);
use HTTP::Request;
use Test::More;
use Test::MockObject::Extends;
use LWP::UserAgent;

has stash => (
    metaclass => 'Collection::Hash',
    is => 'ro',
    isa => 'HashRef',
    default => sub { +{} },
    provides => {
        get => 'stash_get',
        set => 'stash_set',
    }
);

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

has gungho => (
    is => 'ro',
    isa => 'Gungho',
    lazy_build => 1,
    clearer => 'clear_gungho',
    handles => [ 'fetch' ]
);

has gungho_args => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
    provides => {
        elements => 'all_gungho_args',
    }
);

after add_trait => sub {
    $_[0]->clear_gungho();
};

sub setup { }
sub teardown { }

sub _build_gungho_args { return [] }
sub _build_traits { [] }
sub _build_gungho {
    my $self = shift;
    Class::MOP::load_class('Gungho');

    my %traits;
    my @traits;
    foreach my $t ($self->all_traits) {
        push @traits, $t unless $traits{$t}++;
    }

    note("Setting up Gungho with the following Traits: ", explain([@traits]));

    my $object = Gungho->new_with_traits(
        $self->all_gungho_args,
        agent => Test::MockObject::Extends->new(LWP::UserAgent->new()),
        traits => \@traits,
    );
    return $object;
}

1;
