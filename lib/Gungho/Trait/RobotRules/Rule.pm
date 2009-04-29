package Gungho::Trait::RobotRules::Rule;
use Moose;
use namespace::clean -except => qw(meta);
use URI;

has rules => (
    is => 'rw',
    isa => 'HashRef'
);

sub allowed {
    my ($self, $uri) = @_;

    $uri = URI->new($uri) unless blessed $uri;
    my $str   = $uri->path_query || '/';
    my $rules = $self->rules;

    # XXX - There seems to be a problem where each %$rules doesn't get
    # reset when we get out of the while loop in the middle of execution.
    # We do this stupid hack to make sure that the context is reset correctly
    keys %$rules;
    while (my ($key, $list) = each %$rules) {
        next unless $self->is_me($key);

        foreach my $rule (@$list) {
            return 1 unless length $rule;
            return 0 if index($str, $rule) == 0;
        }
        return 1;
    }
    return 1;

}

sub is_me {
    my $self = shift;
    my $name = shift;

    return $name eq '*' || index(lc($self->agent->agent), lc($name)) >= 0;
}

__PACKAGE__->meta->make_immutable;

1;
