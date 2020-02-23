%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(action_resolver_client).
-callback resolve_action(chatbot:userId(), chatbot:action(), chatbot:entities()) ->
  NextAction :: chatbot:message().
