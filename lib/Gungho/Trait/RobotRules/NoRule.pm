package Gungho::Trait::RobotRules::NoRule;
use MooseX::Singleton;

sub allowed { 1 };

__PACKAGE__->meta->make_immutable();

