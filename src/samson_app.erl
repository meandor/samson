%%%-------------------------------------------------------------------
%% @doc samson public API
%% @end
%%%-------------------------------------------------------------------
-module(samson_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  lager:start(),
  lager:info("Loading configs"),
  {ok, Port} = application:get_env(samson, port),
  {ok, GoogleChatEndpoint} = application:get_env(samson, google_chat_endpoint),

  lager:info("Metrics: Starting"),
  prometheus:start(),
  metrics_registry:register(),
  lager:info("Metrics: Started"),

  lager:info("Supervisor: Starting "),
  SupervisorStarted = samson_sup:start_link(),
  lager:info("Supervisor: Started "),

  lager:info("HTTP Server: Starting on port ~p", [Port]),
  Dispatch = cowboy_router:compile([{'_', endpoints:routes(GoogleChatEndpoint)}]),
  {ok, _} = cowboy:start_clear(http_listener, [{port, Port}], #{env => #{dispatch => Dispatch}}),
  lager:info("HTTP Server: Started"),

  SupervisorStarted.

stop(_State) ->
  lager:info("Initiating graceful shutdown"),
  lager:info("HTTP Server: Initiating graceful shutdown"),
  ok = cowboy:stop_listener(http_listener),
  lager:info("HTTP Server: Done graceful shutdown"),
  lager:info("Metrics: Initiating graceful shutdown"),
  prometheus:stop(),
  lager:info("Metrics: Done graceful shutdown"),
  lager:info("Supervisor: Initiating graceful shutdown"),
  ok = init:stop(),
  lager:info("Supervisor: Done graceful shutdown").
