-module(training).

-export([
		loop/0,
		loop2/0
		]).

loop() ->
	receive
		{link, PID} -> 
			link(PID),
			loop();
		die ->
			exit("DIE")		% Force app to die
	end.

loop2() ->
	process_flag(trap_exit, true),
	receive
		{link, PID} -> 
			link(PID),
			loop2();
		die ->
			exit("DIE");
		ExitMessage ->
			io:format("~p~n", [ExitMessage]),
			loop2()
	end.