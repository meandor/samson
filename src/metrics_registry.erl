%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(metrics_registry).
-include("metrics_registry.hrl").
-export([register/0, metered_execution/3]).

register() ->
  prometheus_histogram:new([
    {name, ?HTTP_REQUESTS},
    {labels, [method, path]},
    {buckets, [100, 300, 500, 750, 1000]},
    {help, "Http Request execution time"}]),
  prometheus_counter:new([
    {name, ?HTTP_REQUESTS_TOTAL},
    {labels, [method, path, status]},
    {help, "Http request count"}]),
  prometheus_counter:new([
    {name, ?MESSAGES_PROCESSED_TOTAL},
    {labels, [status]},
    {help, "Total count of all messages that were processed so far"}]),
  prometheus_gauge:new([
    {name, ?MESSAGES_PROCESSING},
    {help, "Number of incoming messages that are being processed"}]),
  prometheus_histogram:new([
    {name, ?NER_DURATION},
    {buckets, [5, 10, 25, 50, 150]},
    {help, "Named entity recognition execution time"}]),
  prometheus_histogram:new([
    {name, ?DUCKLING_REQUESTS},
    {buckets, [100, 300, 500, 750, 1000]},
    {help, "Duckling client http Request execution time"}]),
  prometheus_counter:new([
    {name, ?DUCKLING_REQUESTS_TOTAL},
    {labels, [status]},
    {help, "Duckling client http request count"}]).

metered_execution(MetricName, Fn, Args) ->
  Start = os:system_time(millisecond),
  Result = apply(Fn, Args),
  End = os:system_time(millisecond),
  Duration = End - Start,
  prometheus_histogram:observe(MetricName, Duration),
  Result.
