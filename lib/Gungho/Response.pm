package Gungho::Response;
use Moose;
use MooseX::NonMoose;
use MooseX::AttributeHelpers;
use HTTP::Response;
use namespace::clean -except => qw(meta);

BEGIN { extends 'HTTP::Response' }

has notes => (
    metaclass => 'Collection::Hash',
    is => 'ro',
    isa => 'HashRef',
    required => 1,
    lazy_build => 1,
    provides => {
        clear => 'notes_clear',
        get => 'notes_get',
        set => 'notes_set',
    }
);

sub _build_notes { return +{} }

sub new_from_response {
    my ($class, $response) = @_;
    return $class->new( $response->code, $response->message, $response->headers, $response->content );
}

__PACKAGE__->meta->make_immutable;

1;
