%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(metrics_registry).
-include("metrics_registry_h.hrl").
-export([register/0, metered_execution_duration/3]).
% TODO: Add metrics for http requests, messages processed, duckling client
register() ->
  prometheus_histogram:new([
    {name, ?HTTP_REQUESTS},
    {labels, [method, path, status]},
    {buckets, [100, 300, 500, 750, 1000]},
    {help, "Http request execution time"}]),
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
    {name, ?INTENT_DURATION},
    {buckets, [5, 10, 25, 50, 150]},
    {help, "Intent classification execution time"}]),
  prometheus_histogram:new([
    {name, ?DUCKLING_REQUESTS},
    {labels, [status]},
    {buckets, [100, 300, 500, 750, 1000]},
    {help, "Duckling client http request execution time"}]),
  prometheus_histogram:new([
    {name, ?RASA_INTENT_REQUESTS},
    {labels, [status]},
    {buckets, [100, 300, 500, 750, 1000]},
    {help, "Rasa intent client http request execution time"}]).

metered_execution_duration(MetricName, Fn, Args) ->
  Start = os:system_time(),
  try
    Result = apply(Fn, Args),
    prometheus_histogram:observe(MetricName, os:system_time() - Start),
    Result
  catch
    Class:Reason:Stacktrace ->
      prometheus_histogram:observe(MetricName, os:system_time() - Start),
      lager:error(
        "~nStacktrace:~s",
        [lager:pr_stacktrace(Stacktrace, {Class, Reason})]
      ),
      erlang:error(Reason)
  end.
