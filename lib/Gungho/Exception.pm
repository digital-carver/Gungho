package Gungho::Exception;
use Moose;
use namespace::clean -except => qw(meta);

use Exception::Class
    'Gungho::Exception',
    'Gungho::Exception::RedoRequest',
;

__PACKAGE__->meta->make_immutable;
