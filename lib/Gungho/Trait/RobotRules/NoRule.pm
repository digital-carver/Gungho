package Gungho::Trait::RobotRules::NoRule;
use MooseX::Singleton;
use namespace::clean -except => qw(meta);

sub allowed { 1 };

__PACKAGE__->meta->make_immutable();

