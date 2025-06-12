
# CyBus

[![Tests](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml/badge.svg)](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml) ![Platforms](https://img.shields.io/badge/platforms-iPhone%20%7C%20iPad-lightgrey)

[![Download on the App Store](https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us)](https://apps.apple.com/us/app/cybus/id6745707612)

iOS application with schedules, routes, and locations of buses in Cyprus.

# Setup

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
