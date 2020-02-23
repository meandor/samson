%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(action_resolver).
-behaviour(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(SERVER, ?MODULE).

start_link(ActionResolverClient) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [ActionResolverClient], []).

init(ActionResolverClient) -> {ok, ActionResolverClient}.

-spec resolve_action(function(), chatbot:userId(), chatbot:action(), chatbot:entities()) -> chatbot:message().
resolve_action(ActionResolverClient, UserId, Action, Entities) ->
  apply(ActionResolverClient, [UserId, Action, Entities]).

handle_call({resolveAction, UserId, Action, Entities}, _From, [ActionResolverClient]) ->
  lager:info("Starting to resolve action: ~p", [{UserId, Action, Entities}]),
  Response = resolve_action(ActionResolverClient, UserId, Action, Entities),
  lager:info("Resolved action to: ~p", [Response]),
  {reply, Response, [ActionResolverClient]}.

handle_cast(_Request, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.
