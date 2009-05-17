package Gungho::Trait::Authentication;
use Moose::Role;
use HTTP::Status ();
use namespace::clean -except => qw(meta);

requires 'authenticate';

before fixup_response => sub {
    $_[0]->check_authentication_challange(@_);
};

sub check_authentication_challenge {
    my ($self, $res) = @_;

    # Check if there was a Auth challenge. If yes and Gungho is configured
    # to support authentication, then do the auth magic
    my $code = $res->code;

    if ( $code == &HTTP::Status::RC_UNAUTHORIZED ||
         $code == &HTTP::Status::RC_PROXY_AUTHENTICATION_REQUIRED )
    {
        my $proxy = ($code == &HTTP::Status::RC_PROXY_AUTHENTICATION_REQUIRED);
        my $ch_header = $proxy ? "Proxy-Authenticate" : "WWW-Authenticate";
        my @challenge = $res->header($ch_header);

        if (! @challenge) {
#            $c->log->debug("Response from " . $req->uri . " returned with code = $code, but is missing Authenticate header");
            $res->header("Client-Warning" => "Missing Authenticate header");
            goto DONE;
        }
CHALLENGE:
        for my $challenge (@challenge) {
            $challenge =~ tr/,/;/; # "," is used to separate auth-params!!
            ($challenge) = HTTP::Headers::Util::split_header_words($challenge);
            my $scheme = lc(shift(@$challenge));
            shift(@$challenge); # no value 
            $challenge = { @$challenge };  # make rest into a hash
            for (keys %$challenge) {       # make sure all keys are lower case
                $challenge->{lc $_} = delete $challenge->{$_};
            }

            unless ($scheme =~ /^([a-z]+(?:-[a-z]+)*)$/) {
#                $c->log->debug("Response from " . $req->uri . " returned with code = $code, bad authentication scheme '$scheme'");
                $res->header("Client-Warning" => "Bad authentication scheme '$scheme'");
                goto DONE;
            }
            $scheme = ucfirst $1;  # untainted now

            return $self->authenticate($proxy, $challenge, $res);
        }
        return 0;
    }
DONE:
    return 1;
}

1;
