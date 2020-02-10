%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(google_chat_handler).

%% API
-export([init/2, terminate/3]).

init(Request, State) ->
  <<"POST">> = cowboy_req:method(Request),
  true = cowboy_req:has_body(Request),

  {ok, RawEvent, _} = cowboy_req:read_body(Request),
  Event = jiffy:decode(RawEvent, [return_maps]),
  Answer = chatbot:answer(Event),

  Response = cowboy_req:reply(
    200,
    #{<<"content-type">> => <<"application/json">>},
    jiffy:encode(#{text => Answer}),
    Request
  ),

  {ok, Response, State}.

terminate(_Reason, _Req, _State) -> ok.
