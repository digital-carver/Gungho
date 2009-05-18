use strict;
use lib "t/lib";
use Test::FITesque;

run_tests {
    test {
        [ 'Gungho::Test::Core::RobotsMETA' ],
        [ 'setup' ],
        [ 'parse' ],
        [ 'teardown' ],
    }
};
