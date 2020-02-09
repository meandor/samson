%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(endpoints_test).

-include_lib("eunit/include/eunit.hrl").

health_endpoint_test() ->
  Actual = endpoints:routes("foo"),
  Expected = {"/health", health_handler, []},
  ?assert(lists:member(Expected, Actual)).

google_chat_endpoint_test("foo") ->
  Actual = endpoints:routes(),
  Expected = {"/gchat/foo", google_chat_handler, []},
  ?assert(lists:member(Expected, Actual)).
