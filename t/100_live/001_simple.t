use strict;
use lib "t/lib";

use Gungho::Test::Live::Simple;
Gungho::Test::Live::Simple->runtests;

__END__
use Test::More (tests => 2);
use Gungho::Agent;
use HTTP::Request;

my $ua = Gungho::Agent->new_with_traits (
    traits => [ 'Gungho::Trait::BlockPrivateIP' ]
);

{
    my $res = $ua->fetch(HTTP::Request->new(GET => 'http://www.endeworks.jp'));
    ok($res->is_success);
}

{
    my $res = $ua->fetch(HTTP::Request->new(GET => 'http://127.0.0.1'));
    ok(! $res->is_success, "private IP should be blocked");
}