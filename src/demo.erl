-module(demo).
-include_lib("geo/include/geo.hrl").
-compile(export_all).

init() ->
    mnesia:change_table_copy_type(schema, node(), disc_copies),
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(loc,[{disc_copies,[node()]},
                             {type,set},
                             {attributes,record_info(fields,loc)}]),
    %% mnesia:wait_for_tables([loc],infinity),
    _Seed = rand:seed(exs1024s,{erlang:phash2([node()]),
                                erlang:monotonic_time(),
                                erlang:unique_integer()}),
    F = fun () -> [begin
                           Lon = math:pi()*rand:uniform(),
                           Lat = math:pi()*rand:uniform()/2,
                           mnesia:write(loc,#loc{id=X,name=X,lat=Lat,lon=Lon},write)
                   end || X <- lists:seq(1,1000000)] end,
    mnesia:async_dirty(F).

find(Loc,Dist) ->
    Q = geo:filter(Loc,Dist,mnesia:table(loc)),
    R = mnesia:async_dirty(fun() -> qlc:eval(Q) end),
    lists:map(fun(Loc1) -> [Loc1, geo:distance(Loc,Loc1)] end, R).
