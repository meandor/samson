%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(duckling_client).

-export([recognize_entities/1, extract_entities/1]).

-export_type([entities/0]).

-type entities() :: list().

extract_entity(EntityMap) ->
  Dimension = maps:get(<<"dim">>, EntityMap),
  ValueMap = maps:get(<<"value">>, EntityMap),
  Value = maps:get(<<"value">>, ValueMap),
  {binary_to_atom(Dimension, utf8), binary_to_list(Value)}.

-spec extract_entities(binary()) -> entities().
extract_entities(Body) ->
  EntitiesMap = jiffy:decode(Body, [return_maps]),
  Entities = lists:map(fun extract_entity/1, EntitiesMap),
  lager:info("~p ~p", [Body, Entities]),
  Entities.

-spec recognize_entities(chatbot:message()) -> entities().
recognize_entities(Message) ->
  Locale = "en_GB",
  {ok, DucklingAPI} = application:get_env(samson, duckling_api),
  Method = post,
  Headers = [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}],
  URLEncodedMessage = http_uri:encode(binary_to_list(Message)),
  Payload = list_to_binary("locale=" ++ Locale ++ "&text=" ++ URLEncodedMessage),
  lager:info("sending request to duckling"),
  lager:info("~p ~p ~p ~p", [Method, list_to_binary(DucklingAPI), Headers, Payload]),
  {ok, 200, RespHeaders, ClientRef} = hackney:request(Method, list_to_binary(DucklingAPI), Headers, Payload, []),
  lager:info("got response from duckling ~p ~p", [RespHeaders, ClientRef]),
  {ok, Body} = hackney:body(ClientRef),
  extract_entities(Body).
