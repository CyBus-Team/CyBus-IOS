//
//  BusClusterEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 21/05/2025.
//

import CoreLocation

struct BusClusterEntity: Equatable {
    
    let buses: [BusEntity]

    var coordinate: CLLocationCoordinate2D {
        let lat = buses.map(\.position.latitude).reduce(0, +) / Double(buses.count)
        let lon = buses.map(\.position.longitude).reduce(0, +) / Double(buses.count)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
