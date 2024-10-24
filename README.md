
# CyBus
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

## Optional

### Generate Protobuf
Make sure that you've installed `protobuf`:
```
brew install protobuf
```

Geolocation data is provided by a protobuf service. Response data is based on this [specification](https://github.com/google/transit/blob/master/gtfs-realtime/proto/gtfs-realtime.proto).

If you want to update it, do this:
```
cd Protos
protoc --swift_out=. gtfs-realtime.proto
```

# TODO for MVP

[✅] - Show route info (start, finish, stops) - (issue) [https://github.com/PopovVA/CyBus/issues/1]

[📋] - Setup CI/CD - (issue) [https://github.com/PopovVA/CyBus/issues/2]

[✅] - Setup env - (issue) [https://github.com/PopovVA/CyBus/issues/3]

[📋] - Add localization - (issue) [https://github.com/PopovVA/CyBus/issues/4]

[✅] - Update architecture - (issue) [https://github.com/PopovVA/CyBus/issues/5]

[📋] - Create UI - (issue) [https://github.com/PopovVA/CyBus/issues/6]

# TODO enhancement

[📋] - Move GTFS and routes generation to one REST API service - (issue) [https://github.com/PopovVA/CyBus/issues/7]

[✅] - Add unit tests - (issue) [https://github.com/PopovVA/CyBus/issues/8]

[📋] - Add analytics - (issue) [https://github.com/PopovVA/CyBus/issues/9]

# TODO ideas

[📋] - Add Bolt integration - (issue) [https://github.com/PopovVA/CyBus/issues/10]
