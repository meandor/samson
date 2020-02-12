%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(utils_test).
-include_lib("eunit/include/eunit.hrl").

first_should_return_first_with_only_one_element_test() ->
  Actual = utils:first([a]),
  Expected = a,

  ?assertEqual(Expected, Actual).

first_should_return_first_with_n_elements_test() ->
  Actual = utils:first([a, b, c]),
  Expected = a,

  ?assertEqual(Expected, Actual).
