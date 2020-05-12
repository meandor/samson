%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(intent_classifier_client).
-callback classify_intent(Message :: chatbot:message()) ->
  [chatbot:intent(), ...].
