geo
===

Functions to find points within a distance of a latitude/longitude
using bounding coordinates.

Based on http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates
and https://github.com/rovarghe/clj-geolocation

Usage
-----

```erlang
1> c(geo).
{ok,geo}
2> rr(geo).
[loc]
3> LAX = geo:fromDeg(#loc{lat=33.9415933,lon=-118.410724}).
#loc{lat = 0.5923925564578474,lon = -2.06665700347027}
4> SFO = geo:fromDeg(#loc{lat=37.6213171,lon=-122.3811494}).
#loc{lat = 0.6566158523318447,lon = -2.135953999405083}
5> JFK = #loc{lat=0.7093247608354885,lon=-1.2877097358131546}.
#loc{lat = 0.7093247608354885,lon = -1.2877097358131546}
6> geo:distance(LAX,SFO).
543.6609394051334
7> geo:distance(SFO,JFK).
4152.05968678295
8> geo:distance(LAX,JFK).
3974.341864171459
9> RadiusOfJupiter = 200 * geo:earthR().
1274202.0
10> geo:distance(LAX,SFO,RadiusOfJupiter).
108732.18788102666
11> lists:map(fun geo:toDeg/1,geo:bounds(JFK,10)).
[{40.55138308056653,-73.89885158677538},
 {40.73124711943347,-73.6618146132246}]
12> lists:map(fun geo:toDeg/1,geo:bounds(JFK,10,RadiusOfJupiter)).
[{40.64086543990283,-73.7809256922546},
 {40.64176476009716,-73.77974050774539}]
```
