%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(duckling_client_test).

-include_lib("eunit/include/eunit.hrl").

should_get_one_entity_from_body_test() ->
  GivenBody = <<"[{
   \"body\":\"tomorrow at eight\",
   \"start\": 0,
   \"value\": {
      \"value\":\"2020-02-11T08:00:00.000-08:00\",
      \"grain\":\"hour\",
      \"type\":\"value\"
   },
   \"end\": 17,
   \"dim\": \"time\"}]">>,

  Actual = duckling_client:extract_entities(GivenBody),
  Expected = [{time, "2020-02-11T08:00:00.000-08:00"}],

  ?assertEqual(Expected, Actual).

should_get_n_entities_from_body_test() ->
  GivenBody = <<"[{
    \"body\":\"tomorrow at eight\",
    \"start\":0,
    \"value\":{
      \"values\":[
       {\"value\":\"2020-02-11T08:00:00.000-08:00\",
        \"grain\":\"hour\",
        \"type\":\"value\"},
       {\"value\":\"2020-02-11T20:00:00.000-08:00\",
        \"grain\":\"hour\",
        \"type\":\"value\"}
       ],
      \"value\":\"2020-02-11T08:00:00.000-08:00\",
      \"grain\":\"hour\",
      \"type\":\"value\"},
    \"end\":17,
    \"dim\":\"time\",
    \"latent\":false},
  {\"body\":\"today at 1pm\",\"start\":22,\"value\":
  {\"values\":[{\"value\":\"2020-02-10T13:00:00.000-08:00\",\"grain\":
  \"hour\",\"type\":\"value\"}],\"value\":\"2020-02-10T13:00:00.000-08:00\",
  \"grain\":\"hour\",\"type\":\"value\"},\"end\":34,\"dim\":\"time\",
  \"latent\":false}]">>,

  Actual = duckling_client:extract_entities(GivenBody),
  Expected = [{time, "2020-02-11T08:00:00.000-08:00"}, {time, "2020-02-10T13:00:00.000-08:00"}],

  ?assertEqual(Expected, Actual).
