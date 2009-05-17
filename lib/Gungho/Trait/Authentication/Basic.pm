package Gungho::Trait::Authentication::Basic;
use Moose::Role;
use namespace::clean -except => qw(meta);

with 'Gungho::Trait::Authentication';

has _basic_auth_credentials => (
);

1;