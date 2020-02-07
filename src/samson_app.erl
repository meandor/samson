%%%-------------------------------------------------------------------
%% @doc samson public API
%% @end
%%%-------------------------------------------------------------------

-module(samson_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    samson_sup:start_link().

stop(_State) ->
    ok.
