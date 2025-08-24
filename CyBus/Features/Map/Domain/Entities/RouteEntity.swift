//
//  RouteEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation
import CoreLocation

struct RouteEntity: Equatable {
    let stops: [StopEntity]
    let firstStop: StopEntity
    let lastStop: StopEntity
    let shape: [ShapeEntity]
}

struct StopEntity: Equatable {
    let description: String
    let position: CLLocationCoordinate2D
    
    static func == (lhs: StopEntity, rhs: StopEntity) -> Bool {
        lhs.position.latitude == rhs.position.latitude &&
        lhs.position.longitude == rhs.position.longitude
    }
}

struct ShapeEntity: Equatable {
    let position: CLLocationCoordinate2D
    
    static func == (lhs: ShapeEntity, rhs: ShapeEntity) -> Bool {
        lhs.position.latitude == rhs.position.latitude &&
        lhs.position.longitude == rhs.position.longitude
    }
}
