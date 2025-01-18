//
//  SearchTripEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

struct SearchTripEntity {
    let id: String
    let stopsIds: [SearchStopEntityID]
    let shapes: [TripShapeEntity]
    
    static func from(dto: SearchTripDTO) -> SearchTripEntity {
        SearchTripEntity(
            id: dto.id,
            stopsIds: dto.stopsIds,
            shapes: dto.shapes.map { TripShapeEntity(id: $0.id, location: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), sequence: $0.sequence) }
        )
    }
}

struct TripShapeEntity {
    let id: String
    let location: CLLocationCoordinate2D
    let sequence: Int
}
