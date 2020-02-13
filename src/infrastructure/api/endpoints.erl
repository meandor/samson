%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(endpoints).
-include("../../metrics_registry_h.hrl").
-export([routes/1, response/4]).

response(Start, Request, StatusCode, ResponseBody) ->
  Path = binary_to_list(maps:get(path, Request, <<"undefined">>)),
  Method = binary_to_list(maps:get(method, Request, <<"undefined">>)),
  lager:info("~p", [Request]),
  prometheus_histogram:observe(?HTTP_REQUESTS, [Method, Path, StatusCode], os:system_time() - Start),
  cowboy_req:reply(
    StatusCode,
    #{<<"content-type">> => <<"application/json">>},
    jiffy:encode(ResponseBody),
    Request
  ).

routes(GoogleChatEndpoint) ->
  [
    {"/health", health_handler, []},
    {"/gchat/" ++ GoogleChatEndpoint, google_chat_handler, [fun chatbot:answer/1]},
    {"/metrics", metrics_handler, [fun prometheus_text_format:format/0]}
  ].
