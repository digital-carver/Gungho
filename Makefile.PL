use strict;
use inc::Module::Install;

name 'Gungho';
all_from 'lib/Gungho.pm';
requires 'Exception::Class';
requires 'LWP::UserAgent';
requires 'Moose';
requires 'MooseX::AttributeHelpers';

recommends 'Regexp::Common';

test_requires 'Test::UseAllModules';
test_requires 'Test::Class';

tests 't/*.t t/*/*.t';
auto_include_deps;
WriteAll;