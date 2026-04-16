%%%-------------------------------------------------------------------
%% @doc telegram_bot_logger public API
%% @end
%%%-------------------------------------------------------------------

-module(telegram_bot_logger_app).

-behaviour(application).

-export([start/2, stop/1]).

 

start(_StartType, _StartArgs) ->
    telegram_bot_logger_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
