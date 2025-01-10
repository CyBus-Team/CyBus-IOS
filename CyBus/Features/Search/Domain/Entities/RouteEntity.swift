//
//  RouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 10/01/2025.
//

import Foundation
import CoreLocation

struct RouteEntity : Equatable {
    let id: String
    let stops: [RouteStopEntity]
    let shapes: [RouteShapeEntity]
}

struct RouteStopEntity : Identifiable, Equatable {
    let id: String
    let location: CLLocationCoordinate2D
    let routeIds: [String]
}

struct RouteShapeEntity : Equatable {
    let id: String
    let location: CLLocationCoordinate2D
    let sequence: Int
}
