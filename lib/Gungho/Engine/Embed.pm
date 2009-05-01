package Gungho::Engine::Embed;
use Moose::Role;
use MooseX::AttributeHelpers;

with 'Gungho::Role::Engine';

has requests => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef[HTTP::Request]',
    default => sub { [] },
    provides => {
        push  => 'add_request',
        shift => 'next_request',
    }
);

sub run {
    my $self = shift;
    while (my $req = $self->next_request) {
        $self->handle_request($req);
    }
    return ();
}

1;