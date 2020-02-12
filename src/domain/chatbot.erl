%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(chatbot).

-export([answer/1]).
-export_type([event/0, message/0, entities/0]).

-type event() :: map().
-type message() :: binary().
-type entities() :: list().
-type intent() :: {Name :: atom(), Probability :: number()}.

-spec answer(event()) -> message().
answer(Event) ->
  {ok, Message} = maps:find(<<"message">>, Event),
  {ok, Text} = maps:find(<<"text">>, Message),
  lager:info("Generating answer for: ~p", [Text]),

  Entities = gen_server:call(ner, {userMessage, Text}),
  lager:info("Got entities: ~p", [Entities]),

  Intent = gen_server:call(intent_classifier, {classifyIntent, Text}),
  lager:info("Got intent: ~p", [Intent]),
  <<"foo">>.
