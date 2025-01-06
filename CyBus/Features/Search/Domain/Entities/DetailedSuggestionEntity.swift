//
//  AddressEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import CoreLocation
import MapboxSearch

struct DetailedSuggestionEntity: Identifiable, Equatable, Hashable {
    static func == (lhs: DetailedSuggestionEntity, rhs: DetailedSuggestionEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let name: String
    let description: String
    let location: CLLocationCoordinate2D
    let result: PlaceAutocomplete.Result?
    
    static func from(dto: DetailedSuggestionDTO) -> DetailedSuggestionEntity? {
        guard let id = dto.id, let location = dto.result.coordinate else {
            return nil
        }
        return .init(id: id, name: dto.result.name, description: dto.result.description ?? "", location: location, result: dto.result)
    }
}

extension DetailedSuggestionEntity {
    static var mock: DetailedSuggestionEntity {
        return DetailedSuggestionEntity(
            id: UUID().uuidString,
            name: "Mock name",
            description: "Mock Description",
            location: CameraFeature.defaultLocation,
            result: nil
        )
    }
}
