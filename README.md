
# CyBus

[![Tests](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml/badge.svg)](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml) ![Platforms](https://img.shields.io/badge/platforms-iPhone%20%7C%20iPad-lightgrey)

iOS application with schedules, routes, and locations of buses in Cyprus.

# Setup

### ENV

Create `Config-Secret.xcconfig` and paste your sentry DSN excluding `https://` part

```
SentryDSN=YOUR_DSN_URL
```
Example
```
SentryDSN=123@123.ingest.de.sentry.io/123
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
