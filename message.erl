-module(message).

-export([
		server/1,
		client/1
	]).


server(Clients) ->
	receive
		{connect, Client} ->				% Client connect to server
			io:format("Welcome ~p~n", [Client]),	% '~p' for unknown type
			NewClients = [Client | Clients],
			Client ! {connected, self()},
			server(NewClients);
		{message, Message} ->				% Server receive message from
			% io:format("Server got ~s~n", Message),
			lists:foreach(fun(Client) -> Client ! {notify, Message} end, Clients),
			server(Clients)
	end
.

client(Server) ->
	receive
		{notify, Message} ->
			io:format("received ~s~n", [Message]),
			client(Server);
		{connected, Server} ->
			% io:format("Connected to ~s~n", Server),
			client(Server);
		{broadcast, Message} ->
			Server ! {message, Message},
			client(Server)
	end
.
