use strict;
use lib "t/lib";
use Test::FITesque;

run_tests {
    test {
        [ 'Gungho::Test::Core::BlockPrivateIP' ],
        [ 'setup' ],
        [ 'private_127_X_X_X' ],
        [ 'private_172_16_X_X' ],
        [ 'private_192_168_X_X' ],
        [ 'teardown' ],
    }
};


