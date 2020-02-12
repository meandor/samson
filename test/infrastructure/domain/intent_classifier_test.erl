%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(intent_classifier_test).

-include_lib("eunit/include/eunit.hrl").

handle_call_should_return_unknown_intent_when_nothing_found_test() ->
  prometheus:start(),
  metrics_registry:register(),
  GivenIntentClassifierClient = fun(_Text) -> {} end,

  {reply, Actual, _} = intent_classifier:handle_call({classifyIntent, <<"foo">>}, foo, [GivenIntentClassifierClient]),
  Expected = {unknown, 1.0},

  ?assertEqual(Expected, Actual).

handle_call_should_return_unknown_intent_when_error_occured_test() ->
  GivenIntentClassifierClient = fun(_Text) -> erlang:error(foo) end,

  {reply, Actual, _} = intent_classifier:handle_call({classifyIntent, <<"foo">>}, foo, [GivenIntentClassifierClient]),
  Expected = {unknown, 1.0},

  ?assertEqual(Expected, Actual).

handle_call_should_return_classified_intent_test() ->
  Expected = {foo, 0.5},
  GivenIntentClassifierClient = fun(_Text) -> Expected end,
  {reply, Actual, _} = intent_classifier:handle_call({classifyIntent, <<"foo">>}, foo, [GivenIntentClassifierClient]),

  ?assertEqual(Expected, Actual),
  prometheus:stop().
