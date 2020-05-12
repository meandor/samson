%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(health_handler).

%% API
-export([init/2, terminate/3]).

init(Request, State) ->
  Response = cowboy_req:reply(
    200,
    #{<<"content-type">> => <<"application/json">>},
    jiffy:encode(#{status => <<"up">>}),
    Request
  ),
  {ok, Response, State}.

terminate(_Reason, _Req, _State) -> ok.
