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

is_empty_type_string_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"">>,
    <<"user">> => #{
      <<"name">> => <<"bar">>,
      <<"email">> => <<"foo@bar.com">>
    }
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = false,

  ?assertEqual(Expected, Actual).

is_empty_user_name_string_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"foo">>,
    <<"user">> => #{
      <<"name">> => <<"">>,
      <<"email">> => <<"foo@bar.com">>
    }
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = false,

  ?assertEqual(Expected, Actual).

is_empty_user_email_string_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"foo">>,
    <<"user">> => #{
      <<"name">> => <<"bar">>,
      <<"email">> => <<"">>
    }
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = false,

  ?assertEqual(Expected, Actual).

is_valid_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"foo">>,
    <<"user">> => #{
      <<"name">> => <<"bar">>,
      <<"email">> => <<"foo@bar.com">>
    }
  },

  Actual = google_chat_handler:is_valid_event(GivenEvent),
  Expected = true,

  ?assertEqual(Expected, Actual).

should_extract_message_from_added_to_space_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"ADDED_TO_SPACE">>,
    <<"space">> => #{
      <<"name">> => <<"spaces/AAAAAAAAAAA">>,
      <<"displayName">> => <<"Chuck Norris Discussion Room">>,
      <<"type">> => <<"ROOM">>
    },
    <<"user">> => #{
      <<"name">> => <<"users/12345678901234567890">>,
      <<"email">> => <<"chuck@example.com">>
    }
  },

  Actual = google_chat_handler:extract_message(GivenEvent),
  Expected = <<"ADDED_TO_SPACE">>,

  ?assertEqual(Expected, Actual).

should_extract_message_from_message_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"MESSAGE">>,
    <<"space">> => #{
      <<"name">> => <<"spaces/AAAAAAAAAAA">>,
      <<"displayName">> => <<"Chuck Norris Discussion Room">>,
      <<"type">> => <<"ROOM">>
    },
    <<"message">> => #{
      <<"text">> => <<"foo">>
    },
    <<"user">> => #{
      <<"name">> => <<"users/12345678901234567890">>,
      <<"email">> => <<"chuck@example.com">>
    }
  },

  Actual = google_chat_handler:extract_message(GivenEvent),
  Expected = <<"foo">>,

  ?assertEqual(Expected, Actual).

should_extract_message_from_removed_from_space_event_test() ->
  GivenEvent = #{
    <<"type">> => <<"REMOVED_FROM_SPACE">>,
    <<"space">> => #{
      <<"name">> => <<"spaces/AAAAAAAAAAA">>,
      <<"displayName">> => <<"Chuck Norris Discussion Room">>,
      <<"type">> => <<"ROOM">>
    },
    <<"user">> => #{
      <<"name">> => <<"users/12345678901234567890">>,
      <<"email">> => <<"chuck@example.com">>
    }
  },

  Actual = google_chat_handler:extract_message(GivenEvent),
  Expected = <<"REMOVED_FROM_SPACE">>,

  ?assertEqual(Expected, Actual).
