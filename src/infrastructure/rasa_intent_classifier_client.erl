%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(rasa_intent_classifier_client).
-behavior(intent_classifier_client).
-include("../metrics_registry_h.hrl").
-export([classify_intent/1, extract_intents/1]).

extract_intent(IntentMap) ->
  Intent = binary_to_atom(maps:get(<<"name">>, IntentMap), utf8),
  Confidence = maps:get(<<"confidence">>, IntentMap),
  {Intent, Confidence}.

extract_intents(ResponseMap) ->
  IntentsMap = maps:get(<<"intent_ranking">>, ResponseMap),
  lists:map(fun extract_intent/1, IntentsMap).

call_rasa_intents_api(Start, RasaApi, Payload) ->
  Headers = [{<<"Content-Type">>, <<"application/json">>}],
  {ok, StatusCode, _RespHeaders, ClientRef} = hackney:request(post, RasaApi, Headers, Payload, []),
  prometheus_histogram:observe(?RASA_INTENT_REQUESTS, [StatusCode], os:system_time() - Start),
  if
    StatusCode == 200 ->
      {ok, Body} = hackney:body(ClientRef),
      extract_intents(jiffy:decode(Body, [return_maps]));
    true ->
      lager:error("Error getting response from rasa intent API. Got status code: ~p", [StatusCode]),
      []
  end.

classify_intent_with_rasa(Message) ->
  Start = os:system_time(),
  {ok, RasaIntentAPI} = application:get_env(samson, rasa_intent_api),

  Payload = jiffy:encode(#{<<"text">> => Message}),
  try
    call_rasa_intents_api(Start, list_to_binary(RasaIntentAPI), Payload)
  catch
    Class:Reason:Stacktrace ->
      lager:error("Error calling rasa intent api"),
      lager:error(
        "~nStacktrace:~s",
        [lager:pr_stacktrace(Stacktrace, {Class, Reason})]
      ),
      []
  end.

classify_intent(Message) ->
  case Message of
    <<"ADDED_TO_SPACE">> -> [{added_to_space, 1.0}];
    <<"REMOVED_FROM_SPACE">> -> [{removed_from_space, 1.0}];
    _ -> classify_intent_with_rasa(Message)
  end.
