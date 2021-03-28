use strict;
use warnings;

use Test::More;

my $filename = "./testperl/Parse/Man.pm" ;
local $/;
open my $fh, $filename or die $!;
my $perlfile = <$fh>;
close $fh;

require_ok('PLS::Handler');

my $handler = new_ok("PLS::Handler");

#"params":{"textDocument":{"uri":"file:///home/buu/foo.test","languageId":"coctest","version":1,"text":"\n"}}
my $didopen = {
	textDocument =>{
		uri => "file://$filename", #TODO Does this need to be absolute?
		languageId => "test",
		version => 1,
		text => $perlfile,
	}
};

$handler->did_open($didopen);

#{"textDocument":{"uri":"file:///home/buu/foo.test"},"position":{"line":0,"character":0}}
my $definition = {
	textDocument => {
		uri => "file://$filename",
	},
	position => {
		line => 36,
		character => 15, #should be _change_para_options(
	},
};

my $res = $handler->definition($definition);

is( $res->{range}->{start}->{line}, 369 );
is( $res->{range}->{start}->{character}, 0 );
