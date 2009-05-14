package Gungho::Test;
use Moose;
use Moose::Util::TypeConstraints;
use Test::FITesque::Test;

use namespace::clean -except => qw(meta);

subtype 'Gungho::Test::FixtureSpec'
    => as 'ArrayRef',
;
coerce 'Gungho::Test::FixtureSpec'
    => from 'Str'
    => via  {
        my $class = $_;
        if ($class !~ s/^\+//) {
            $class = "Gungho::Test::" . $class;
        }
        Class::MOP::load_class($class);
        [ $class ]
    }
;

has fixture => (
    is => 'ro',
    isa => 'Gungho::Test::FixtureSpec',
    coerce => 1
);

has data => (
    is => 'ro',
    isa => 'ArrayRef[ArrayRef]',
    lazy_build => 1
);

sub fixture_class {
    return $_[0]->fixture->[0];
}
sub _build_data {
    my $self = shift;
    my $fixture_class = $self->fixture_class;
    my $data = $fixture_class->default_data;
    return $data;
}

sub run_tests {
    my $self = shift;
    Test::FITesque::Test->new({
        data => [
            $self->fixture,
            @{ $self->data },
        ]
    })->run_tests;
}

1;

