geo
===

Functions to find points within a distance of a latitude/longitude
using bounding coordinates.

Based on http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates
and https://github.com/rovarghe/clj-geolocation

Usage
-----
```bash
$ git clone git://github.com/xafizoff/geo && cd geo
$ mad com pla rep
```

```erlang
1> rr(geo).
[loc]
2> LAX = geo:fromDeg(#loc{lat=33.9415933,lon=-118.410724}).
#loc{lat = 0.5923925564578474,lon = -2.06665700347027}
3> SFO = geo:fromDeg(#loc{lat=37.6213171,lon=-122.3811494}).
#loc{lat = 0.6566158523318447,lon = -2.135953999405083}
4> JFK = #loc{lat=0.7093247608354885,lon=-1.2877097358131546}.
#loc{lat = 0.7093247608354885,lon = -1.2877097358131546}
5> geo:distance(LAX,SFO).
543.6609394051334
6> geo:distance(SFO,JFK).
4152.05968678295
7> geo:distance(LAX,JFK).
3974.341864171459
8> RadiusOfJupiter = 200 * geo:earthR().
1274202.0
9> geo:distance(LAX,SFO,RadiusOfJupiter).
108732.18788102666
10> lists:map(fun geo:toDeg/1,geo:bounds(JFK,10)).
[#loc{lat = 40.55138308056653,lon = -73.89885158677538},
 #loc{lat = 40.73124711943347,lon = -73.6618146132246}]
11> lists:map(fun geo:toDeg/1,geo:bounds(JFK,10,RadiusOfJupiter)).
[#loc{lat = 40.64086543990283,lon = -73.7809256922546},
 #loc{lat = 40.64176476009716,lon = -73.77974050774539}]
```
