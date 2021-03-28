package PLS::Handler;

use strict;
use warnings;
use utf8;

use JSON; # Need the constants

sub new {
	my $class = shift;

	my $self = bless {}, $class;

	$self->{supported_methods} = {
		"initialize"              => "initialize",
		"initialized"             => "initialized",
		"textDocument/didOpen"    => "did_open",
		"textDocument/definition" => "definition",
	};

	return $self;
}

sub execute {
	my $self = shift;
	my $req  = shift;

	if ( my $method = $self->{supported_methods}->{ $req->{method} } ) {
		return $self->$method( $req->{params} );
	}
}

sub initialize {

	return {
		result => {
			capabilities => {
				textDocumentSync => {
					openClose => JSON::true,
					change    => 1,
				},
				definitionProvider  => JSON::true,
				declarationProvider => JSON::true,
			}
		}
	};
}

sub initialized {
	return;
}

#"params":{"textDocument":{"uri":"file:///home/buu/foo.test","languageId":"coctest","version":1,"text":"\n"}}
sub did_open {
	my $self   = shift;
	my $params = shift;

	#TODO Parse the $params->{text};

	return;    #Notification, no output;
}

#{"textDocument":{"uri":"file:///home/buu/foo.test"},"position":{"line":0,"character":0}}
sub definition {
	my $self   = shift;
	my $params = shift;

	#TODO IMPLEMENT ME
	return {
		result => {
			uri   => "file:///foo",
			range => {
				start => {
					line      => 1,
					character => 2,
				},
				end => {
					line      => 1,
					character => 4,
				}
			}
		}
	};

}

1;
