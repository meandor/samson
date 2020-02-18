%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(named_entity_recognition).
-behaviour(gen_server).
-include("../metrics_registry_h.hrl").
-export([init/1, handle_call/3, handle_cast/2, start_link/1]).

start_link(NERClient) ->
  gen_server:start_link({local, ner}, ?MODULE, [NERClient], []).

init(NERClient) ->
  {ok, NERClient}.

recognize_entities(Text, NERClient) ->
  lager:info("Starting named entity recognition for: ~p", [Text]),
  Entities = metrics_registry:metered_execution_duration(?NER_DURATION, NERClient, [Text]),
  lager:info("Extracted entities: ~p", [Entities]),
  Entities.

handle_call({userMessage, _UserId, Message}, _From, [NERClient]) ->
  try
    Entities = recognize_entities(Message, NERClient),
    {reply, Entities, [NERClient]}
  catch
    Class:Reason:Stacktrace ->
      lager:error("Could not recognize entities"),
      lager:error(
        "~nStacktrace:~s",
        [lager:pr_stacktrace(Stacktrace, {Class, Reason})]
      ),
      {reply, [], [NERClient]}
  end;
handle_call(terminate, _From, State) ->
  lager:info("Named entity recognition shutdown: Starting"),
  lager:info("Named entity recognition shutdown: Done"),
  {stop, normal, ok, State}.

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).
