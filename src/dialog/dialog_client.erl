%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(dialog_client).
-callback choose_next_action(chatbot:userId(), chatbot:intent(), chatbot:entities()) ->
  NextAction :: chatbot:action().
