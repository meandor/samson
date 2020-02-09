%%%-------------------------------------------------------------------
%% @doc samson top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(samson_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 5,
                 period => 2},
    ChildSpecs = [
      #{
        id => ner,
        start =>
        {named_entity_recognition, start_link, []},
        shutdown => 3,
        type => worker
      }
    ],
    {ok, {SupFlags, ChildSpecs}}.
