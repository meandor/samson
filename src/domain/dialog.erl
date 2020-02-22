%%%-------------------------------------------------------------------
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(dialog).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(SERVER, ?MODULE).

start_link(DialogClient) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [DialogClient], []).

init(DialogClient) -> {ok, DialogClient}.

-spec choose_next_action(function(), chatbot:intent(), chatbot:entities()) -> chatbot:action().
choose_next_action(DialogClient, Intent, Entities) ->
  apply(DialogClient, [{Intent, Entities}]).

handle_call({chooseNextAction, Intent, Entities}, _From, [DialogClient]) ->
  lager:info("Starting to choose next action for state: ~p", [{Intent, Entities}]),
  NextAction = choose_next_action(DialogClient, Intent, Entities),
  lager:info("Chose next action: ~p", [NextAction]),
  {reply, NextAction, [DialogClient]}.

handle_cast(_Request, State) ->
  {noreply, State}.

terminate(_Reason, _State) -> ok.
