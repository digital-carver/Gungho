use strict;
use inc::Module::Install;

name 'Gungho';
all_from 'lib/Gungho.pm';
requires 'namespace::clean';
requires 'Exception::Class';
requires 'HTML::RobotsMETA';
requires 'LWP::UserAgent';
requires 'Moose';
requires 'MooseX::AttributeHelpers';
requires 'MooseX::Traits';
requires 'Net::DNS';
requires 'Regexp::Common';

test_requires 'Test::More' => '0.82';
test_requires 'Test::UseAllModules';
test_requires 'Test::FITesque';
test_requires 'Test::CleanNamespaces';

tests 't/*.t t/*/*.t';
auto_include_deps;
WriteAll;