package Gungho::Test;
use Moose;
use MooseX::AttributeHelpers;
use namespace::clean -except => qw(meta);
use HTTP::Request;
use Test::MockObject::Extends;

extends 'Test::Class';

has traits => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        push => 'add_trait'
    }
);

has agent => (
    is => 'rw',
    isa => 'Gungho::Agent',
    lazy_build => 1,
    handles => [ 'fetch' ]
);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self = $class->meta->new_object(
        __INSTANCE__ => $self,
        @_
    );
    return $self;
}

sub _build_agent {
    my $self = shift;
    Class::MOP::load_class('Gungho::Agent');
    Gungho::Agent->new_with_traits(
        traits => $self->traits,
        agent  => Test::MockObject::Extends->new(
            LWP::UserAgent->new()
        )->set_always( request => HTTP::Response->new(200, "OK") )
    );
}

1;
