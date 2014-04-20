-module(list_server).
-behaviour(gen_server).
-export([start_link/0]).
-export([
		init/1,
		handle_call/3,
		handle_cast/2,
		handle_info/2,
		terminate/2,
		code_change/3,
		push/1,
		get_all/0,
		test/0,
		pop/0
		]).
-define(SERVER, ?MODULE).

-record(state, {}).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

push(Val) ->
    gen_server:cast(?SERVER, {push, Val}).

get_all() ->
    gen_server:call(?SERVER, get_all).

test() ->
    "test".

pop() ->
    gen_server:call(?SERVER, pop).

init([]) ->
	{ok, #state{}}.

handle_call(Request, _Form, State) ->
	case Request of			% We must use 'case' since we do not wait for input by ourself 
		get_all ->
			{reply, State, State};
		pop ->
			[Val|NewState] = State,
			{reply, Val, NewState};
		_Else ->
			Reply = {return, Request},
			{reply, Reply, State}
	end.
	
handle_cast(Request, State) ->
	case Request of
		{push, Val} ->
			NewState = [Val|State],
			{noreply, NewState};
		_default ->
			{noreply, State}
	end.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
