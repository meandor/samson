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
    {"/gchat/" ++ GoogleChatEndpoint, google_chat_handler, []}
  ].
