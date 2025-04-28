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
        guard let latitude = Double(dto.lat), let longitude = Double(dto.lon) else {
            return nil
        }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return .init(id: dto.id, label: dto.displayName, location: location)
    }
}
