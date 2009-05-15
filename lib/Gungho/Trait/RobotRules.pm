package Gungho::Trait::RobotRules;
use Moose::Role;
use namespace::clean -except => qw(meta);
use Gungho::Exception;
use Gungho::Trait::RobotRules::Rule;
use Gungho::Trait::RobotRules::NoRule;
use WWW::RobotRules::Parser;

has robot_rules_parser => (
    is => 'ro',
    required => 1,
    lazy_build => 1,
);

before verify_request => sub {
    my $self = shift;
    my $req  = shift;

    # Have we verified this before? (do cache)

    if ($req->uri->path ne '/robots.txt') {
        my $rule = $self->load_rule($req);
        if (! $rule->allowed($req->uri)) {
            Gungho::Exception->throw("Rejected by robot rules");
        }
    }
    return ();
};

sub _build_robot_rules_parser { return WWW::RobotRules::Parser->new }

sub load_rule {
    my ($self, $req) = @_;

    my $host = $req->header('Host') || $req->uri->host;

    my $rule;

    if (! $rule) {
        my $req = HTTP::Request->new(GET => "http://$host/robots.txt");
        my $res = $self->fetch($req);
        if ($res->is_success) {
            my $h = $self->robot_rules_parser->parse("http://$host", $res->content);
            $rule = Gungho::Trait::RobotRules::Rule->new(rules => $h);
        } else {
            $rule = Gungho::Trait::RobotRules::NoRule->instance;
        }
    }

    return $rule;
}

1;