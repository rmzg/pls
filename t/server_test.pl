#!/usr/bin/perl

use strict;
use warnings;
use utf8;

#use Symbol 'gensym';
use IPC::Open3 qw/open3/;
$/ = "\r\n";

#my($in_fh,$out_fh,$err_fh);
open3( my $in_fh, my $out_fh, my $err_fh, './server.pl') or die $?;

my $json = q|{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"processId":639832,"rootPath":"/home/buu/tmp/lsp","rootUri":"file:///home/buu/tmp/lsp","capabilities":{"workspace":{"applyEdit":true,"workspaceEdit":{"documentChanges":true,"resourceOperations":["create","rename","delete"],"failureHandling":"textOnlyTransactional"},"didChangeConfiguration":{"dynamicRegistration":true},"didChangeWatchedFiles":{"dynamicRegistration":true},"symbol":{"dynamicRegistration":true,"symbolKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},"tagSupport":{"valueSet":[1]}},"executeCommand":{"dynamicRegistration":true},"configuration":true,"workspaceFolders":true},"textDocument":{"publishDiagnostics":{"relatedInformation":true,"versionSupport":false,"tagSupport":{"valueSet":[1,2]}},"synchronization":{"dynamicRegistration":true,"willSave":true,"willSaveWaitUntil":true,"didSave":true},"completion":{"dynamicRegistration":true,"contextSupport":true,"completionItem":{"snippetSupport":true,"commitCharactersSupport":true,"documentationFormat":["markdown","plaintext"],"deprecatedSupport":true,"preselectSupport":true,"tagSupport":{"valueSet":[1]}},"completionItemKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}},"hover":{"dynamicRegistration":true,"contentFormat":["markdown","plaintext"]},"signatureHelp":{"dynamicRegistration":true,"contextSupport":true,"signatureInformation":{"documentationFormat":["markdown","plaintext"],"activeParameterSupport":true,"parameterInformation":{"labelOffsetSupport":true}}},"definition":{"dynamicRegistration":true},"references":{"dynamicRegistration":true},"documentHighlight":{"dynamicRegistration":true},"documentSymbol":{"dynamicRegistration":true,"symbolKind":{"valueSet":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]},"hierarchicalDocumentSymbolSupport":true,"tagSupport":{"valueSet":[1]}},"codeAction":{"dynamicRegistration":true,"isPreferredSupport":true,"codeActionLiteralSupport":{"codeActionKind":{"valueSet":["","quickfix","refactor","refactor.extract","refactor.inline","refactor.rewrite","source","source.organizeImports"]}}},"codeLens":{"dynamicRegistration":true},"formatting":{"dynamicRegistration":true},"rangeFormatting":{"dynamicRegistration":true},"onTypeFormatting":{"dynamicRegistration":true},"rename":{"dynamicRegistration":true,"prepareSupport":true},"documentLink":{"dynamicRegistration":true,"tooltipSupport":true},"typeDefinition":{"dynamicRegistration":true},"implementation":{"dynamicRegistration":true},"declaration":{"dynamicRegistration":true},"colorProvider":{"dynamicRegistration":true},"foldingRange":{"dynamicRegistration":true,"rangeLimit":5000,"lineFoldingOnly":true},"selectionRange":{"dynamicRegistration":true}},"window":{"workDoneProgress":true}},"initializationOptions":{},"trace":"verbose","workspaceFolders":[{"uri":"file:///home/buu/tmp/lsp","name":"lsp"}],"clientInfo":{"name":"coc.nvim","version":"0.0.80"},"workDoneToken":"4b67e71a-5f23-42a4-916b-5f8bcbca5c05"}}|;


print $in_fh "Content-Length: ",length($json),$/,$/, $json;

my $accum = "";
while(<$out_fh>){
	if($_ eq $/){last;}
	$accum .= $_;
}

$accum =~ /Content-Length: (\d+)/ or die;
my $out_json;
read($out_fh, $out_json, $1);

print $out_json,"\n";

print "OK 1\n" if $out_json =~ /"declarationProvider":true/;
