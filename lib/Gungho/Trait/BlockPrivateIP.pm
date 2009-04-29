package Gungho::Trait::BlockPrivateIP;
use Moose::Role;
use Gungho::Exception;

my $re;
BEGIN {
    if (0){ # eval "use Regexp::Common qw(net); 1") {
#        $re = qr/^$RE{net}{IPv4}{-keep}$/;
    } else {
        my $ipunit = '25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}';
        my $ipsep  = '[.]';
        $re = "^(($ipunit)$ipsep($ipunit)$ipsep($ipunit)$ipsep($ipunit))\$";
    }
}

before verify_request => sub {
    my $self = shift;
    my $req  = shift;

    my $address = $req->uri->host;
    if ($address =~ /$re/x) {
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