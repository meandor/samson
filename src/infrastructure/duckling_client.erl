%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(duckling_client).
-behaviour(ner_client).
-include("../metrics_registry_h.hrl").
-export([recognize_entities/1, extract_entities/1]).

extract_entity_value(Value) ->
  if
    is_binary(Value) -> binary_to_list(Value);
    true -> Value
  end.

extract_entity(EntityMap) ->
  Dimension = maps:get(<<"dim">>, EntityMap),
  ValueMap = maps:get(<<"value">>, EntityMap),
  Value = maps:get(<<"value">>, ValueMap),
  {binary_to_atom(Dimension, utf8), extract_entity_value(Value)}.

-spec extract_entities(binary()) -> chatbot:entities().
extract_entities(Body) ->
  EntitiesMap = jiffy:decode(Body, [return_maps]),
  lists:map(fun extract_entity/1, EntitiesMap).

call_api(Start, Api, Payload) ->
  Headers = [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}],
  {ok, StatusCode, _RespHeaders, ClientRef} = hackney:request(post, Api, Headers, Payload, []),
  prometheus_histogram:observe(?DUCKLING_REQUESTS, [StatusCode], os:system_time() - Start),
  if
    StatusCode == 200 ->
      {ok, Body} = hackney:body(ClientRef),
      extract_entities(Body);
    true ->
      lager:error("Error getting response from Duckling API. Got status code: ~p", [StatusCode]),
      []
  end.

-spec recognize_entities(chatbot:message()) -> chatbot:entities().
recognize_entities(Message) ->
  Locale = "en_GB",
  {ok, DucklingAPI} = application:get_env(samson, duckling_api),
  URLEncodedMessage = http_uri:encode(binary_to_list(Message)),
  Payload = list_to_binary("locale=" ++ Locale ++ "&text=" ++ URLEncodedMessage),
  Start = os:system_time(),
  try
    call_api(Start, list_to_binary(DucklingAPI), Payload)
  catch
    Class:Reason:Stacktrace ->
      lager:error("Error calling duckling api"),
      lager:error(
        "~nStacktrace:~s",
        [lager:pr_stacktrace(Stacktrace, {Class, Reason})]
      ),
      []
  end.
