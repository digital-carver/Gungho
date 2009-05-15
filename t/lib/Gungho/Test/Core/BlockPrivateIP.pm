package Gungho::Test::Core::BlockPrivateIP;
use Moose;
use MooseX::NonMoose;
BEGIN { extends 'Test::FITesque::Fixture' }
use namespace::clean -except => qw(meta);

with 'Gungho::Test::Role::Basic';
with 'Gungho::Test::Role::BlockPrivateIP';

__PACKAGE__->meta->make_immutable();