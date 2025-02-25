//
//  SearchStopEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

typealias SearchStopEntityID = String

struct SearchStopEntity {
    let id: SearchStopEntityID
    let tripIds: [String]
    let location: CLLocationCoordinate2D
    let city: String
    
    static func from(dto: SearchStopDTO) -> SearchStopEntity {
        SearchStopEntity(
            id: dto.id,
            tripIds: dto.tripIds,
            location: CLLocationCoordinate2D(
                latitude: dto.latitude,
                longitude: dto.longitude
            ),
            city: dto.city
        )
    }
}
