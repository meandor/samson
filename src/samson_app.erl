%%%-------------------------------------------------------------------
%% @doc samson public API
%% @end
%%%-------------------------------------------------------------------

-module(samson_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  lager:start(),
  Dispatch = cowboy_router:compile([{'_', endpoints:routes()}]),
  {ok, _} = cowboy:start_clear(
    samson_http_listener,
    [{port, 8080}],
    #{env => #{dispatch => Dispatch}}
  ),
  samson_sup:start_link().

stop(_State) ->
  init:stop(),
  ok = cowboy:stop_listener(http).
