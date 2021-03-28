package PLS::Handler;

use strict;
use warnings;
use utf8;

sub new {
	my $class = shift;

	my $self = bless {}, $class;

	$self->{supported_methods} = {
		"initialize" => "initialize",
		"initialized" => "initialized",
		"textDocument/definition" => "definition",
	};

	return $self;
}

sub execute {
	my $self = shift;
	my $req = shift;

	if( my $method = $self->{supported_methods}->{$req->{method}}) {
		return $self->$method($req->{params});
	}
}

sub initialize {

return {
			result => {
				capabilities => {
					definitionProvider  => JSON::true,
					declarationProvider => JSON::true,
				}
			}
		}
}

sub initialized {
	return;
}

#{"textDocument":{"uri":"file:///home/buu/tmp/lsp/foo.test"},"position":{"line":0,"character":0}}
sub definition {
	my $params = shift;

	#TODO IMPLEMENT ME

	return;

}

1;
