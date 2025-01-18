//
//  SearchStopEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

struct SearchStopEntity {
    let id: String
    let tripIds: [String]
    let location: CLLocationCoordinate2D
    
    static func from(dto: SearchStopDTO) -> SearchStopEntity {
        SearchStopEntity(id: dto.id, tripIds: dto.tripIds, location: CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude))
    }
}
