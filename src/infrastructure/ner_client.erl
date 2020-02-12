%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(ner_client).
-callback recognize_entities(Message :: chatbot:message()) ->
  Entities :: chatbot:entities().
