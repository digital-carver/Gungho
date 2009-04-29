package Gungho::Role::Engine;
use Moose::Role;
use namespace::clean -except => qw(meta);

requires 'run';

1;
