%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(metrics_handler).


%% API
-export([init/2, terminate/3]).

init(Request, [RenderMetricsFn]) ->
  Response = cowboy_req:reply(
    200,
    #{<<"content-type">> => <<"text/plain">>},
    RenderMetricsFn(),
    Request
  ),
  {ok, Response, [RenderMetricsFn]}.

terminate(_Reason, _Req, _State) -> ok.