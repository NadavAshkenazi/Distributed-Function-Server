%%%-------------------------------------------------------------------
%%% @author Nadavash
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Jun 2021 17:56
%%%-------------------------------------------------------------------
-module(server_loadBalance_callback).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, internal_calcFun/4]).
-author("Nadavash").


init(_Arg0) ->
  {ok, 0}.

% returns the current state (number of jobs)
handle_call(jobsNum, _From, S) ->
  {reply, S, S};

% default func
handle_call(_Message, _From, S) ->
  {reply, S, S}.

% default func
handle_cast({calc, Pid, F, MsgRef, Server_id}, S) ->
  spawn_link(?MODULE, internal_calcFun, [Pid, F, MsgRef, Server_id]),
  {noreply, S + 1};

% decreasing state when done calculating
handle_cast(finished, S) ->
  {noreply, S - 1}.

handle_info(_info, S)->
  {noreply, S}.

terminate(_Reason, _S)->
  ok.

code_change(_, S, _)->
  {ok, S}.

% calculates the function requested
internal_calcFun(Pid, F, MsgRef, Server_id)->
  Result = F(),
  Pid ! {MsgRef, Result},
  gen_server:cast(Server_id, finished).
