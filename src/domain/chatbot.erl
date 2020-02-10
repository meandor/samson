%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(chatbot).

-export([answer/1]).

-spec answer(map()) -> binary().
answer(Event) ->
  {ok, Message} = maps:find(<<"message">>, Event),
  {ok, Text} = maps:find(<<"text">>, Message),
  Entities = gen_server:call(ner, {userMessage, Text}),
  lager:info("Got entities: ~p", [Entities]),
  <<"foo">>.
