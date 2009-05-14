use strict;
use inc::Module::Install;

name 'Gungho';
all_from 'lib/Gungho.pm';
requires 'Exception::Class';
requires 'LWP::UserAgent';
requires 'Moose';
requires 'MooseX::AttributeHelpers';
requires 'MooseX::Traits';
requires 'Net::DNS';
requires 'Regexp::Common';

test_requires 'Test::More' => '0.82';
test_requires 'Test::UseAllModules';
test_requires 'Test::FITesque';

tests 't/*.t t/*/*.t';
auto_include_deps;
WriteAll;