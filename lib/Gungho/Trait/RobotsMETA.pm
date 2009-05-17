package Gungho::Trait::RobotsMETA;
use Moose::Role;
use HTML::RobotsMETA;
use namespace::clean -except => qw(meta);

has robots_meta_parser => (
    is => 'ro',
    isa => 'HTML::RobotsMETA',
    lazy_build => 1,
    required => 1
);

sub _build_robots_meta_parser {
    return HTML::RobotsMETA->new();
}

after fixup_response => sub {
    my ($self, $res) = @_;

    if ($res->is_success && $res->content_type =~ m{^text/html}i) {
        my $rules = $self->robots_meta->parse_rules( $res->content );
        $res->notes( robots_meta => $rules );
    }
};

1;
