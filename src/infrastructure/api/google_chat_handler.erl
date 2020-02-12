%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(google_chat_handler).

%% API
-export([init/2, terminate/3, is_valid_event/1]).

is_valid_event(Event) ->
  try
    Type = maps:get(<<"type">>, Event),
    true = is_binary(Type),
    true = Type =/= <<"">>,
    Token = maps:get(<<"token">>, Event),
    true = is_binary(Token),
    true = Token =/= <<"">>,
    lager:info("Got valid request"),
    true
  catch
    _:Reason ->
      lager:error("Got invalid request body with reason: ~p", [Reason]),
      false
  end;
is_valid_event(_Event) ->
  false.

response_for_event(Request, AnswerFn, Event) ->
  ValidEvent = is_valid_event(Event),
  if
    ValidEvent == true ->
      Answer = AnswerFn(Event),
      cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"application/json">>},
        jiffy:encode(#{text => Answer}),
        Request
      );
    true ->
      cowboy_req:reply(
        400,
        #{<<"content-type">> => <<"application/json">>},
        jiffy:encode(#{error => <<"The supplied body is invalid">>}),
        Request
      )
  end.

response_for_body(Request, AnswerFn) ->
  {ReadBodySuccessful, RawEvent, _} = cowboy_req:read_body(Request),
  if
    ReadBodySuccessful == ok ->
      Event = jiffy:decode(RawEvent, [return_maps]),
      response_for_event(Request, AnswerFn, Event);
    true -> cowboy_req:reply(
      400,
      #{<<"content-type">> => <<"application/json">>},
      jiffy:encode(#{error => <<"The supplied body is invalid">>}),
      Request
    )
  end.

init(Request, [AnswerFn]) ->
  <<"POST">> = cowboy_req:method(Request),
  HasBody = cowboy_req:has_body(Request),
  if
    HasBody == true ->
      Response = response_for_body(Request, AnswerFn),
      {ok, Response, [AnswerFn]};
    true ->
      Response = cowboy_req:reply(
        400,
        #{<<"content-type">> => <<"application/json">>},
        jiffy:encode(#{error => <<"Please supply a body">>}),
        Request
      ),
      {ok, Response, [AnswerFn]}
  end.

terminate(_Reason, _Req, _State) -> ok.
