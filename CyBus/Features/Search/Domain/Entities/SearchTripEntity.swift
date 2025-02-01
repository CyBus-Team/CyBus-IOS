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
    let shapes: [TripShapeEntity?]
    
    static func from(dto: SearchTripDTO, shapes: [TripShapeEntity?]) -> SearchTripEntity {
        SearchTripEntity(
            id: dto.id,
            stopsIds: dto.stops,
            shapes: shapes
            
        )
    }
}

struct TripShapeEntity {
    let id: String
    let location: CLLocationCoordinate2D
    let sequence: Int
    
    static func from(dto: ShapeDTO) -> TripShapeEntity? {
        if let latitude = Double(dto.latitude), let longitude = Double(dto.longitude), let sequence = Int(dto.sequence) {
            return TripShapeEntity(id: dto.shapeId, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), sequence: sequence)
        } else {
            return nil
        }
    }
}
