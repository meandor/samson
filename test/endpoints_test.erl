%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(endpoints_test).

-include_lib("eunit/include/eunit.hrl").

health_endpoints_test() ->
  Actual = endpoints:routes(),
  Expected = {"/health", health_handler, []},
  ?assert(lists:member(Expected, Actual)).
