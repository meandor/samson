%%%-------------------------------------------------------------------
%% @doc samson public API
%% @end
%%%-------------------------------------------------------------------

-module(samson_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  lager:start(),
  [Port | GoogleChatEndpointConfig] = application:get_all_env(samson),
  [{google_chat_endpoint, GoogleChatEndpoint}] = GoogleChatEndpointConfig,
  lager:info("Starting HTTP Server on: ~p", [Port]),
  Dispatch = cowboy_router:compile([{'_', endpoints:routes(GoogleChatEndpoint)}]),
  {ok, _} = cowboy:start_clear(
    http_listener,
    [Port],
    #{env => #{dispatch => Dispatch}}
  ),
  lager:info("Started HTTP Server"),
  lager:info("Starting Supervisor"),
  SupervisorStarted = samson_sup:start_link(),
  lager:info("Started Supervisor"),
  SupervisorStarted.

stop(_State) ->
  lager:info("Gracefully shutting down"),
  lager:info("Gracefully shutting down HTTP Server"),
  ok = cowboy:stop_listener(http_listener),
  lager:info("Stopped HTTP Server"),
  lager:info("Gracefully shutting down Supervisor"),
  ok = init:stop(),
  lager:info("Stopped Supervisor").
