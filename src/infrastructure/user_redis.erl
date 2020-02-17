%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(user_redis).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(SERVER, ?MODULE).

%% @doc Spawns the server and registers the local name (unique)
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, RedisUrl} = application:get_env(samson, redis_url),
  {ok, _RedisClient} = eredis:start_link(RedisUrl).

%% @private
%% @doc Handling call messages
handle_call({updateUser, UserId, User}, _From, RedisClient) ->
  {ok, _} = eredis:q(RedisClient, ["HMSET", UserId | User]),
  {reply, ok, RedisClient}.

%% @private
%% @doc Handling cast messages
handle_cast(_Request, State) -> {noreply, State}.

terminate(_Reason, Client) ->
  eredis:stop(Client).
