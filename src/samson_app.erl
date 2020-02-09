%%%-------------------------------------------------------------------
%% @doc samson public API
%% @end
%%%-------------------------------------------------------------------

-module(samson_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  lager:start(),
  Config = application:get_all_env(samson),
  Dispatch = cowboy_router:compile([{'_', endpoints:routes()}]),
  {ok, _} = cowboy:start_clear(
    http_listener,
    Config,
    #{env => #{dispatch => Dispatch}}
  ),
  samson_sup:start_link().

stop(_State) ->
  ok = cowboy:stop_listener(http_listener),
  ok = init:stop().
