
# CyBus

[![Tests](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml/badge.svg)](https://github.com/CyBus-Team/CyBus/actions/workflows/tests.yml) ![Platforms](https://img.shields.io/badge/platforms-iPhone%20%7C%20iPad-lightgrey)

iOS application with schedules, routes, and locations of buses in Cyprus.

## Screenshots

<img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/fc/92/3d/fc923d1c-47ce-0fd6-2f24-cdae397fcf67/Apple_iPhone_16_Pro_Max_Screenshot_3.png/460x0w.webp" alt="CyBus Screen 1" width="200"/>
<img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/85/d9/74/85d97404-28a3-c932-180e-ba553e450088/Apple_iPhone_16_Pro_Max_Screenshot_4.png/460x0w.webp" alt="CyBus Screen 2" width="200"/>
<img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/46/ad/61/46ad617c-bc77-9d47-a1a4-e298efa6b4af/Apple_iPhone_16_Pro_Max_Screenshot_5.png/460x0w.webp" alt="CyBus Screen 3" width="200"/>

## Download
[![Download on the App Store](https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us)](https://apps.apple.com/us/app/cybus/id6745707612) [![Join Beta on TestFlight](https://img.shields.io/badge/TestFlight-Join%20Beta-blue?logo=apple&style=for-the-badge)](https://testflight.apple.com/join/WD62JESV)

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
