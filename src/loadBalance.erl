%%%-------------------------------------------------------------------
%%% @author Nadavash
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Jun 2021 17:55
%%%-------------------------------------------------------------------
-module(loadBalance).
-author("Nadavash").
-export([startServers/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3, server_start_link/1]).



startServers() ->
  server_loadBalance_supervisor:start_link().

stopServers() ->
  exit(whereis(server_loadBalance_supervisor), normal).

% return the number of functions that a specific server is running at the moment
numberOfRunningFunctions(Server_ID) ->
  case Server_ID of
    1 -> gen_server:call(server1, jobsNum);
    2 -> gen_server:call(server2, jobsNum);
    3 -> gen_server:call(server3, jobsNum)
  end.

% send the calculating function to the server with the minimum jobs to do
calcFun(Pid, F, MsgRef) ->
  Server = minServer(),
  gen_server:cast(Server, {calc, Pid, F, MsgRef, Server}).

% returns the server with the minimum jobs at the moment
minServer() ->
  Jobs1 = numberOfRunningFunctions(1),
  Jobs2 = numberOfRunningFunctions(2),
  Jobs3 = numberOfRunningFunctions(3),
  MinAmount = erlang:min(Jobs1, erlang:min(Jobs2, Jobs3)),
  case MinAmount of
    Jobs1 -> server1;
    Jobs2 -> server2;
    Jobs3 -> server3
  end.

%starts the specific server
server_start_link(Server_id) ->
  gen_server:start_link({local, Server_id}, server_loadBalance_callback, [], []).
