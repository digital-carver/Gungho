package Gungho::Engine::Embed;
use Moose::Role;
use MooseX::AttributeHelpers;
use namespace::clean -except => qw(meta);

with
    'Gungho::Role::Engine',
    'Gungho::Role::Agent'
;

has requests => (
    metaclass => 'Collection::Array',
    is => 'ro',
    isa => 'ArrayRef[HTTP::Request]',
    lazy_build => 1,
    provides => {
        push  => 'add_request',
        shift => 'next_request',
    }
);

sub _build_requests { [] }

sub _build_agent {
    Class::MOP::load_class("LWP::UserAgent");
    return LWP::UserAgent->new();
}

sub _build_resolver {
    Class::MOP::load_class("Net::DNS::Resolver");
    return Net::DNS::Resolver->new();
}

sub run {
    my $self = shift;
    while (my $req = $self->next_request) {
        $self->handle_request($req);
    }
    return ();
}

1;