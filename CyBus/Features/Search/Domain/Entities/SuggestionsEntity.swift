//
//  SuggestionEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import CoreLocation

struct SuggestionEntity: Identifiable, Equatable {
    static func == (lhs: SuggestionEntity, rhs: SuggestionEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let label: String
    let location: CLLocationCoordinate2D
    
    static func from(dto: SuggestionDTO) -> SuggestionEntity? {
        let location = CLLocationCoordinate2D(latitude: dto.lat, longitude: dto.lon)
        return .init(id: dto.id, label: dto.name, location: location)
    }
}
