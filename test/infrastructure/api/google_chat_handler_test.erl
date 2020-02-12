%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(google_chat_handler_test).

-include_lib("eunit/include/eunit.hrl").

is_empty_event_test() ->
  GivenEvent = #{},

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = false,

  ?assertEqual(Expected, Actual).

is_empty_string_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"">>,
    <<"token">> => <<"">>
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = false,

  ?assertEqual(Expected, Actual).

is_valid_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"foo">>,
    <<"token">> => <<"bar">>
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = true,

  ?assertEqual(Expected, Actual).
