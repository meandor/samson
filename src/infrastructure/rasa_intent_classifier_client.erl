%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(rasa_intent_classifier_client).
-behavior(intent_classifier_client).

-export([classify_intent/1, extract_intents/1]).

extract_intent(IntentMap) ->
  Intent = binary_to_atom(maps:get(<<"name">>, IntentMap), utf8),
  Confidence = maps:get(<<"confidence">>, IntentMap),
  {Intent, Confidence}.

extract_intents(ResponseMap) ->
  IntentsMap = maps:get(<<"intent_ranking">>, ResponseMap),
  lists:map(fun extract_intent/1, IntentsMap).

classify_intent(Message) ->
  {ok, RasaIntentAPI} = application:get_env(samson, rasa_intent_api),
  Method = post,
  Headers = [{<<"Content-Type">>, <<"application/json">>}],
  Payload = jiffy:encode(#{<<"text">> => Message}),
  {ok, 200, _RespHeaders, ClientRef} = hackney:request(Method, list_to_binary(RasaIntentAPI), Headers, Payload, []),
  {ok, Body} = hackney:body(ClientRef),
  extract_intents(jiffy:decode(Body, [return_maps])).
