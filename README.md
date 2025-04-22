
# CyBus

[![Tests](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml/badge.svg)](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml)

iOS application with schedules, routes, and locations of buses in Cyprus.

# Setup

## Required

You need to create account on MapBox and generate an access token, just follow [this instruction](https://docs.mapbox.com/ios/maps/guides/install/)

After, you have to create `Config-Secret.xcconfig` file in the root directory and paste your access token there

```
MBXAccessToken=YOUR_MAPBOX_ACCESS_TOKEN
GFTSServiceIP=20.19.98.194
GFTSServiceURL=$(GFTSServiceIP):8328/Api/api/gtfs-realtime //"http://20.19.98.194:8328/Api/api/gtfs-realtime"
```

### Generate GFTS
Routes are static files from [motionbuscard](https://motionbuscard.org.cy/opendata).

They are static for now and located in the Generated folder. If you want to update them, go to the `Topology` section and download `routes.zip`, then unzip it to the Generated folder.

Make sure that you've installed these gem dependencies:
```
gem install rgeo -v 3.0.0
gem install dbf -v 4.2.4
gem install rgeo-shapefile -v 3.0.0
```

Afterward, run the Ruby script in the root folder:
```
sh generate.sh
```

# TODO for MVP

[📋] - Setup CI/CD - (issue) [https://github.com/PopovVA/CyBus/issues/2]

[📋] - Add localization - (issue) [https://github.com/PopovVA/CyBus/issues/4]

# TODO enhancement

[📋] - Add unit tests - (issue) [https://github.com/PopovVA/CyBus/issues/8]

[📋] - Add analytics - (issue) [https://github.com/PopovVA/CyBus/issues/9]

# TODO ideas

[📋] - Add Bolt integration - (issue) [https://github.com/PopovVA/CyBus/issues/10]
