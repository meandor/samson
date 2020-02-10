%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(endpoints).

%% API
-export([routes/1]).

routes(GoogleChatEndpoint) ->
  [
    {"/health", health_handler, []},
    {"/gchat/" ++ GoogleChatEndpoint, google_chat_handler, [fun(Event) -> chatbot:answer(Event) end]},
    {"/metrics", metrics_handler, [fun prometheus_text_format:format/0]}
  ].
