-module(exercise1).

% 'export' signify function name
% '/0' signify number of arguments
-export([ 	hello/0, 
			helloIO/0, 
			hello/1, 
			factorial/1, 
			sum/1, 
			sum_tail/2,
			count/1, 
			average/1,
			command/1,
			double_list/1,
			map/2,
			foldl/3,
			foldr/2,
			process_loop/0 ,
			list_process/1 ]).

list_process(List) ->
	receive
		{put, Val} ->
			NewList = [Val|List],
			list_process(NewList);

		print ->
			io:format("~p~n",[List]),
			list_process(List);

		{Caller, pop} ->
			[Val | NewList] = List,
			Caller ! Val,
			list_process(NewList)
	end.

% Waiting for Loop
process_loop() ->
	receive
		Message ->
			io:format("Looping: ~s~n", [Message]),
			process_loop()
	end.  

% Declaring function
hello() ->  			% '->' Signify start function
	"Hello World."
	.					% '.' Signify end of function		

% Arguments in Erlang is a pattern, hence it is possible to overload two function with different pattern
hello(joe) ->
	io:format("Hello Joe.~n")
;

hello(mike) ->
	io:format("Hello Mike.~n")
.	

helloIO() ->
	io:format("Hello world.~n")
.

factorial(0) -> 1;
factorial(1) -> 1;
% when (N > 1) Signify the requirement for pattern N must be more than 1
% This is called Guard
factorial(N) when (N > 1) -> N * factorial(N-1).

% sum([]) ->0;
% sum([H|T]) -> H + sum(T).
% Refactor to use Accumulative variable instead
sum(L) -> sum_tail(L, 0).

sum_tail([], Acc) -> Acc;
sum_tail([H|T], Acc) ->
	sum_tail(T, Acc + H)
.

count([]) -> 0;
count([_|T]) -> 1 + count(T).

% average(L) -> sum(L) / count(L).	
average(L) ->
	if L =/= [] ->
		sum(L) / count(L);
	true ->
		error
	end.

% Message is Tuple 
% i.e. exercise1:command({sum, [1,2,3]}).
command(Message) ->
	case Message of
		{average, L} -> average(L);
		{sum, L} -> sum(L)
	end.

% [1,2,3] => [2,4,6]
double_list([]) -> [];
double_list([H|T]) ->[H*2|double_list(T)].


% lists:map(fun exercise1:average/1, [[1, 2]]).
% F = fun(X) -> X*2 end.  
% exercise1:map(F, [1,2,3]).
% lists:map(fun exercise1:average/1, [[1, 2]]).
% lists:map( fun(W) -> {W,1} end, [a, b, c]).
map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F, T)].

% 0 - ((1 - 2) - 3) = -4
% ((1, 2), 3) = (1, 3) = 2
% foldl(_, []) -> 0;
foldl(F, Acc, [X]) -> F(X, Acc);
% foldl(F, Acc, [X, Y]) -> F(X, Y);
foldl(F, Acc, [H|T]) ->
	foldl(F, F(H, Acc), T)
.

foldr(F, [X, Y]) -> F(X, Y);
foldr(F, [H|T]) -> F(H, foldr(F, T)).

