//
//  BusRouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation
import CoreLocation

struct BusRouteEntity : Equatable {
    
    let shapes: [ShapeEntity]
    let stops: [StopEntity]
    
}

struct StopEntity : Identifiable, Equatable {
    let id: String
    let position: CLLocationCoordinate2D
}

struct ShapeEntity : Equatable {
    let id: String
    let position: CLLocationCoordinate2D
    let sequence: Int
}
