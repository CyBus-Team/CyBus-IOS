# CyBus
IOS application with schedule, routes and locations of buses in Cyprus

# Generate gtfs swift proto file
cd Protos
protoc --swift_out=. gtfs-realtime.proto
