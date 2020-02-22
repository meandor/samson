%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(dialog_client).
-callback choose_next_action(State :: {chatbot:intent(), chatbot:entities()}) ->
  NextAction :: chatbot:action().
