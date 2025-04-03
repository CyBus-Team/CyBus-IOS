//
//  RouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation
import CoreLocation

struct RouteEntity : Equatable {
    let routeId: String
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
