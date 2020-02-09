%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(endpoints_test).

-include_lib("eunit/include/eunit.hrl").

health_endpoint_test() ->
  Actual = endpoints:routes(),
  Expected = {"/health", health_handler, []},
  ?assert(lists:member(Expected, Actual)).

google_chat_endpoint_test() ->
  Actual = endpoints:routes(),
  Expected = {"/gchat", google_chat_handler, []},
  ?assert(lists:member(Expected, Actual)).
