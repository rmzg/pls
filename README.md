Basic code architecture:

server.pl calls PLS::main which parses commandline options and calls PLS::mainloop

PLS::mainloop goes into an infinite loop reading requests and delivering responses over STDIN/STDOUT

After mainloop reads and parses the request, it calls PLS::Handler::execute, which checks to see if we support the request and then calls the appropriate method.

Example:

A textDocument/didOpen notification ends up calling `$handler->did_open(params)`.
