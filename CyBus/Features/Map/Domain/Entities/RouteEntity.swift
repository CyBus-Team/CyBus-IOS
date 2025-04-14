//
//  RouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation
import CoreLocation

struct RouteEntity : Identifiable, Equatable {
    let routeId: String
    let shapes: [ShapeEntity]
    let stops: [StopEntity]
    
    var id : String { routeId }
}

struct StopEntity : Identifiable, Equatable {
    let id: String
    let position: CLLocationCoordinate2D
}

struct ShapeEntity : Identifiable, Equatable {
    let id: String
    let position: CLLocationCoordinate2D
    let sequence: Int
}
