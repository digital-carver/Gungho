package Gungho;
use 5.008;
use Moose;
use namespace::clean -except => qw(meta);

with 'MooseX::Traits';

has '+_trait_namespace' => ( default => 'Gungho' );

our $VERSION = '0.99000';
our $AUTHORITY = 'cpan:DMAKI';

sub BUILDARGS {
    my $class = shift;
    my $args  = $class->SUPER::BUILDARGS(@_);
    if (! $args->{traits} || ! @{ $args->{traits} } ) {
        $args->{traits} = [ 'Engine::Embed' ];
    }
    return $args;
}

__PACKAGE__->meta->make_immutable();

1;

__END__

=head1 SYNOPSIS

    my $g = Gungho->create(
        @args,
        traits => [ 'Engine::Embed', '+MooseX::SimpleConfig' ],
    );
    $g->run;

=cut