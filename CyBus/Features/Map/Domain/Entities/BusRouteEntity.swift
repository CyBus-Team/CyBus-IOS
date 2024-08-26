//
//  BusRouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation
import CoreLocation

struct BusRouteEntity {
    
    let shapes: [ShapeEntity]
    let stops: [StopEntity]
    
}

struct StopEntity : Identifiable {
    let id: String
    let position: CLLocationCoordinate2D
}

struct ShapeEntity {
    let id: String
    let position: CLLocationCoordinate2D
    let sequence: Int
}
