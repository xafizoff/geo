-module(demo).
-include_lib("geo/include/geo.hrl").
-include_lib("stdlib/include/qlc.hrl").
-compile(export_all).

init() ->
    mnesia:create_schema([node()]),
    mnesia:create_table(location,[{ram_copies,[node()]},
                                  {attributes,record_info(fields,location)}]),
    _Seed = rand:seed(exs1024s,{erlang:phash2([node()]),
                                erlang:monotonic_time(),
                                erlang:unique_integer()}),
    F = fun () -> [case X of X ->
                           Lon = math:pi()*rand:uniform(),
                           Lat = math:pi()*rand:uniform()/2,
                           mnesia:write(location,#location{id=X,name=X,lat=Lat,lon=Lon},write)
                   end || X <- lists:seq(1,10000000)] end,
    mnesia:async_dirty(F).

sqr(X) -> X*X.
toLoc(#location{lon=Lon,lat=Lat}) -> #loc{lon=Lon,lat=Lat}.

find(Loc,Dist) ->
    [Min,Max] = geo:bounds(Loc,Dist),
    io:format("Min: ~p, Max: ~p~n",[Min,Max]),
    Q = qlc:q([T||T<-mnesia:table(location),
                  Min#loc.lat =< T#location.lat,
                  Max#loc.lat >= T#location.lat,
                  Min#loc.lon =< T#location.lon,
                  Max#loc.lon >= T#location.lon,
                  geo:distance(Loc,#loc{lat=T#location.lat,lon=T#location.lon}) =< Dist
              ]),
    R = mnesia:async_dirty(fun() -> qlc:eval(Q) end),
    lists:map(fun(#location{lon=Lon,lat=Lat}) -> 
                      [{Lat,Lon},
                       geo:distance(#loc{lat=Lat,lon=Lon},Loc)] end, R).
