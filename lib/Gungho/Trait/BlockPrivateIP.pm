package Gungho::Trait::BlockPrivateIP;
use Moose::Role;
use namespace::clean -except => qw(meta);
use Gungho::Exception;
use Regexp::Common qw(net);

my $IPADDRESS_RE;
BEGIN {
    $IPADDRESS_RE = qr/^$RE{net}{IPv4}{-keep}$/;
}

before verify_request => sub {
    my $self = shift;
    my $req  = shift;

    my $address = $req->uri->host;
    if ($address =~ /$IPADDRESS_RE/x) {
        my ($o1, $o2, $o3, $o4) = ($2, $3, $4, $5);

        my $is_private = 
            ( $o1 eq '10' || $o1 eq '127' ) ? 1 :
            ( $o1 eq '172' && ($o2 >= 16 && $o2 <= 31) ) ? 1 :
            ( $o1 eq '192' && $o2 eq '168' ) ? 1 :
            0
        ;

        if ($is_private) {
            Gungho::Exception->throw(message => "Blocking private address $address");
        }
    }
};

1;