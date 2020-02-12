%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(intent_classifier).
-behaviour(gen_server).
-include("../metrics_registry_h.hrl").

-export([init/1, handle_call/3, handle_cast/2, start_link/1]).

-define(UNKNOWN_INTENT, {unknown, 1.0}).

start_link(IntentClassifierClient) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [IntentClassifierClient], []).

init(IntentClassifierClient) ->
  {ok, IntentClassifierClient}.

classify_intent(IntentClassifierClient, Text) ->
  try
    Intent = metrics_registry:metered_execution(?INTENT_DURATION, IntentClassifierClient, [Text]),
    if
      Intent == {} -> ?UNKNOWN_INTENT;
      true -> Intent
    end
  catch
    Exception:Reason ->
      lager:error("Could not classify intent, exception: ~p, reason: ~p", [Exception, Reason]),
      ?UNKNOWN_INTENT
  end.

handle_call({classifyIntent, Text}, _From, [IntentClassifierClient]) ->
  lager:info("Starting named entity recognition for: ~p", [Text]),
  Intent = classify_intent(IntentClassifierClient, Text),
  lager:info("Classified intent: ~p", [Intent]),
  {reply, Intent, [IntentClassifierClient]};
handle_call(terminate, _From, State) ->
  lager:info("Intent classifier shutdown: Starting"),
  lager:info("Intent classifier shutdown: Done"),
  {stop, normal, ok, State}.

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).
