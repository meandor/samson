%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(chatbot).

-export([answer/2]).
-export_type([message/0, entities/0, intent/0, userId/0, action/0]).

-type userId() :: string().
-type message() :: binary().
-type entities() :: [entity(), ...].
-type entity() :: {Name :: atom(), Value :: string()}.
-type intent() :: {Name :: atom(), Probability :: number()}.
-type action() :: atom().

-spec answer(UserId :: userId(), Message :: message()) -> message().
answer(UserId, Message) ->
  lager:info("Generating answer for: ~p", [Message]),

  Entities = gen_server:call(ner, {userMessage, UserId, Message}),
  lager:info("Got entities: ~p", [Entities]),

  Intent = gen_server:call(intent_classifier, {classifyIntent, UserId, Message}),
  lager:info("Got intent: ~p", [Intent]),

  NextAction = gen_server:call(dialog, {chooseNextAction, UserId, Intent, Entities}),
  lager:info("Got next action: ~p", [NextAction]),

  Response = gen_server:call(action_resolver, {resolveAction, UserId, NextAction, Entities}),
  lager:info("Got response: ~p", [Response]),
  Response.
