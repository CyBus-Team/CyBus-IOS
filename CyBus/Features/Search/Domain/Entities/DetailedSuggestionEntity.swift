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
    let result: PlaceAutocomplete.Result?
    
    static func from(dto: DetailedSuggestionDTO) -> DetailedSuggestionEntity? {
        guard let id = dto.id else {
            return nil
        }
        return .init(id: id, name: dto.result.name, description: dto.result.description ?? "", result: dto.result)
    }
}

extension DetailedSuggestionEntity {
    static var mock: DetailedSuggestionEntity {
        return DetailedSuggestionEntity(
            id: UUID().uuidString,
            name: "Mock name",
            description: "Mock Description",
            result: nil
        )
    }
}
