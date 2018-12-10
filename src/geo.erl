-module(geo).
-export([deg2rad/1,rad2deg/1]).
-export([fromDeg/1,toDeg/1,earthR/0]).
-export([distance/2,distance/3]).
-export([bounds/2,bounds/3]).
-include_lib("geo/include/geo.hrl").

pi() -> math:pi().
deg2rad(Deg) -> Deg*pi()/180.
rad2deg(Rad) -> Rad*180/pi().
earthR() -> 6371.01.

toDeg(#loc{lat=Lat,lon=Lon}) -> #loc{lat=rad2deg(Lat),lon=rad2deg(Lon)}.
fromDeg(#loc{lat=Lat,lon=Lon}) -> #loc{lat=deg2rad(Lat),lon=deg2rad(Lon)}.

distance(From,To) -> distance(From,To,earthR()).
distance(From,To,Rad) -> Rad * (math:acos(math:sin(From#loc.lat)*math:sin(To#loc.lat) +
                                              math:cos(From#loc.lon-To#loc.lon)*math:cos(From#loc.lat)*
                                              math:cos(To#loc.lat))).

calc(Lat,Lon,Dist,MinLat,MaxLat) ->
    case (MinLat > -pi()/2) andalso (MaxLat < pi()/2) of
        true ->
            DLon = math:asin(math:sin(Dist)/math:cos(Lat)),
            MinLon = Lon - DLon,
            MinLon1 = case MinLon < -pi() of
                          true -> MinLon + (2*pi());
                          false -> MinLon
                      end,
            MaxLon = Lon + DLon,
            MaxLon1 = case MaxLon > pi() of
                          true -> MaxLon - (2*pi());
                          false -> MaxLon
                      end,
            {{MinLat,MaxLat},{MinLon1,MaxLon1}};
        false -> {{max(MinLat,-pi()/2),min(MaxLat,pi()/2)},{-pi(),pi()}}
    end.

bounds(Loc,Dist) -> bounds(Loc,Dist,earthR()).
bounds(Loc,Dist,Rad) ->
    Dist1 = Dist / Rad,
    {{Lat1,Lat2},{Lon1,Lon2}} = calc(Loc#loc.lat,Loc#loc.lon,Dist1,
                                     Loc#loc.lat-Dist1,Loc#loc.lat+Dist1),
    [#loc{lat=Lat1,lon=Lon1},#loc{lat=Lat2,lon=Lon2}].
