%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(rasa_intent_classifier_client_test).

-include_lib("eunit/include/eunit.hrl").

extract_intents_should_return_only_one_intent_test() ->
  GivenResponse = #{
    <<"entities">> => [],
    <<"intent">> => #{<<"confidence">> => 0.9, <<"name">> => <<"inform_id">>},
    <<"intent_ranking">> => [
      #{<<"confidence">> => 0.9, <<"name">> => <<"inform_id">>}
    ],
    <<"text">> => <<"foo">>
  },

  Actual = rasa_intent_classifier_client:extract_intents(GivenResponse),
  Expected = [{inform_id, 0.9}],

  ?assertEqual(Expected, Actual).

extract_intents_should_return_n_intents_test() ->
  GivenResponse = #{
    <<"entities">> => [],
    <<"intent">> => #{<<"confidence">> => 0.9, <<"name">> => <<"inform_id">>},
    <<"intent_ranking">> => [
      #{<<"confidence">> => 0.9, <<"name">> => <<"inform_id">>},
      #{<<"confidence">> => 0.1, <<"name">> => <<"foo">>}
    ],
    <<"text">> => <<"foo">>
  },

  Actual = rasa_intent_classifier_client:extract_intents(GivenResponse),
  Expected = [{inform_id, 0.9}, {foo, 0.1}],

  ?assertEqual(Expected, Actual).
