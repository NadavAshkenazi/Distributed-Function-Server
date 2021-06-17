%%%-------------------------------------------------------------------
%%% @author Nadavash
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Jun 2021 17:56
%%%-------------------------------------------------------------------
-module(server_loadBalance_supervisor).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-author("Nadavash").

%% API
-export([]).


start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

% keeps all servers running
init([]) ->
  Server1 = {server1, {loadBalance, server_start_link, [server1]}, permanent, 2000, worker, [server_loadBalance_callback]},
  Server2 = {server2, {loadBalance, server_start_link, [server2]}, permanent, 2000, worker, [server_loadBalance_callback]},
  Server3 = {server3, {loadBalance, server_start_link, [server3]}, permanent, 2000, worker, [server_loadBalance_callback]},
  {ok,{{one_for_all,1,1}, [Server1,Server2,Server3]}}.
