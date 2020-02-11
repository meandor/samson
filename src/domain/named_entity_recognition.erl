%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(named_entity_recognition).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, start_link/1]).

start_link(NERClient) ->
  gen_server:start_link({local, ner}, ?MODULE, [NERClient], []).

init(NERClient) ->
  {ok, NERClient}.

handle_call({userMessage, Text}, _From, NERClient) ->
  lager:info("Starting named entity recognition for: ~p", [Text]),
  Entities = duckling_client:recognize_entities(Text),
  lager:info("Extracted entities: ~p", [Entities]),
  {reply, Entities, NERClient};
handle_call(terminate, _From, State) ->
  lager:info("Named entity recognition shutdown: Starting"),
  lager:info("Named entity recognition shutdown: Done"),
  {stop, normal, ok, State}.

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).
