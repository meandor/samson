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
      start => {
        named_entity_recognition, start_link, [fun duckling_client:recognize_entities/1]
      },
      shutdown => 3,
      type => worker
    },
    #{
      id => intent_classifier,
      start => {
        intent_classifier, start_link, [fun rasa_intent_classifier_client:classify_intent/1]
      },
      shutdown => 3,
      type => worker
    },
    #{
      id => user_redis,
      start =>
      {user_redis, start_link, []},
      shutdown => 3,
      type => worker
    },
    #{
      id => dialog,
      start => {
        dialog,
        start_link,
        [fun(_UserId, _Intent, _Entities) -> foo_action end] %TODO: Add a dialog client function here
      },
      shutdown => 3,
      type => worker
    },
    #{
      id => action_resolver,
      start => {
        action_resolver,
        start_link,
        [fun(_UserId, _Action, _Entities) -> <<"Hi">> end] %TODO: Add a action resolver client function here
      },
      shutdown => 3,
      type => worker
    }
  ],
  {ok, {SupFlags, ChildSpecs}}.
