package PLS;

use strict;
use warnings;
use utf8;

use JSON qw/encode_json decode_json/;


use PLS::Handler;

sub main {
	if ( grep { $_ eq "-h" or $_ eq "--help" } @ARGV ) {
		print "Perl language server. Implements the Language Server Protocol.";
		exit;
	}

open my $LOG, ">", "/tmp/plslogs" or die $!;
$LOG->autoflush(1);
*STDERR = $LOG; #TODO Configuration

	return mainloop();
}

sub mainloop {

	my $handler = PLS::Handler->new;

	STDOUT->autoflush(1);
	$/ = "\r\n";    #LSP Spec dictates both chars

	# Each iteration of this loop reads and responds to a single request from the client
	while (1) {

		# First we read the headers
		my $content_length;
		while (1) {

			my $header = <STDIN>;
			if ( not defined $header ) {

				#STDIN went away?
				exit;
			}
			if ( $header =~ /Content-Length: (\d+)/i ) {
				$content_length = $1;
			}
			elsif ( $header eq $/ ) {
				last;    #header section is terminated by an "empty line"
			}

			# The only other possible header at this moment is Content-Length, which we ignore
		}

		if ( not defined $content_length ) {
			warn "Invalid request, no content-length header received\n";
			next;
		}

		my $body;
		my $ret = read( STDIN, $body, $content_length );
		if ( not defined $ret ) {
			die "Error reading from STDIN: $!\n";
		}
		elsif ( $ret == 0 ) {

			#STDIN went away?
			exit;
		}
		elsif ( length $body != $ret ) {
			warn "Didn't read the correct number of characters for this body: $content_length";
			next;
		}

		warn "--$body--\n";

		my $req = decode_json($body);
		if ( not $req ) {
			warn "Invalid json ==$body==\n";
			next;
		}

		warn JSON->new->pretty->encode($req);

		my $res = $handler->execute($req);

		if ($res) {
			write_response( $req, $res );
		}
	}
}

sub write_response {
	my ( $req, $res ) = @_;

	$res->{id}      = $req->{id};
	$res->{jsonrpc} = "2.0";

	warn "Responding: ", JSON->new->pretty->encode($res);

	my $json   = encode_json($res);
	my $length = length $json;

	print STDOUT "Content-Length: $length\r\n\r\n$json";
}

1;
