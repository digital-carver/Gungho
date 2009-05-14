package Gungho::Test::Fixture;
use Moose;
use MooseX::AttributeHelpers;
use namespace::clean -except => qw(meta);
use HTTP::Request;
use Test::MockObject::Extends;

BEGIN { extends 'Test::FITesque::Fixture' };

has traits => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
    provides => {
        push => 'add_trait'
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
    

=head1
has default_data => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef]',
    lazy_build => 1,
);
=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self = $class->meta->new_object(
        __INSTANCE__ => $self,
        @_
    );
    return $self;
}

sub setup { }
sub teardown { }

sub _build_traits { [] }
sub _build_agent {
    my $self = shift;
    Class::MOP::load_class('Gungho');

    Gungho->new_with_traits(
        $self->all_agent_args,
        traits => $self->traits,
    );
}

sub default_data {
    my $self = shift;
    my @list = grep { 
        !/^_/ && !/^setup|teardown|meta|BUILD|BUILDARGS|DEMOLISH|DESTROY$/
    } $self->meta->get_method_list();
    return [ [ 'setup' ], (map { [ $_ ] } @list), [ 'teardown' ] ];
}

1;
