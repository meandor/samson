%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(named_entity_recognition).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, start_link/0]).

start_link() ->
  gen_server:start_link({local, ner}, ?MODULE, [], []).

init(_Args) ->
  InitialState = [],
  {ok, InitialState}.

handle_call({userMessage, Text}, _From, _State) ->
  lager:info("Starting named entity recognition for: ~p", [Text]),
  Entities = [],
  lager:info("Extracted entities: ~p", [Entities]),
  {reply, Entities, []};
handle_call(terminate, _From, State) ->
  {stop, normal, ok, State}.

handle_cast(Request, State) -> % async
  erlang:error(not_implemented).