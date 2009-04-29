use strict;
use inc::Module::Install;

name 'Gungho';
all_from 'lib/Gungho.pm';
requires 'Moose';

test_requires 'Test::UseAllModules';

tests 't/*.t t/*/*.t';
auto_include_deps;
WriteAll;