package Gungho::Trait::Log::Memory;
use Moose::Role;
use namespace::clean -except => qw(meta);
use MooseX::AttributeHelpers;

with 'Gungho::Trait::Log';

has logs => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { +[] },
    provides => {
        elements => 'all_logs',
        push     => 'add_log',
    }
);

sub log {
    my $self = shift;
    $self->add_log([ @_ ]);
}

1;