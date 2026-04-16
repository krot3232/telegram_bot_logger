-module(telegram_bot_logger_server).
-behaviour(gen_server).

%% API
-export([stop/0, start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include_lib("kernel/include/logger.hrl").

-define(TIME,30000).

stop() ->
    gen_server:call(?MODULE, stop).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
    {ok, #{timer=>erlang:send_after(0,self(),send_info)}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(send_info, #{timer:=OldTime}=State) ->
    erlang:cancel_timer(OldTime,[{async, true},{info, false}]),
    
    ProcCount    = erlang:system_info(process_count),
    MemTot       = erlang:memory(total),

    ?LOG_INFO("
<b>Process count:</b>~p
<b>Memory total:</b>~p", [ProcCount,MemTot]),
    {noreply, State#{timer=>erlang:send_after(?TIME,self(),send_info)}};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
 