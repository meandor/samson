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

google_chat_endpoint_test() ->
  [_H, Actual | _] = endpoints:routes("foo"),
  {"/gchat/foo", google_chat_handler, _} = Actual.

metrics_endpoint_test() ->
  [_H, _R, Actual] = endpoints:routes("foo"),
  {"/metrics", metrics_handler, _} = Actual.
