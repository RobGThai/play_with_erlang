-module(list_app_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %{ok, { {<restart strategy>, <Max restart>, <Within duration, second>}, <child specs>} }.
    {ok, { {one_for_one, 5, 10}, [
    	{				% This is child specs
    		list_server,
    		{list_server, start_link, []},
    		permanent,
    		brutal_kill,
    		worker,
    		[list_server]
    	}
    ]} }.

