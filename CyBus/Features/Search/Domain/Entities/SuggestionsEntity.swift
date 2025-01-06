//
//  AddressEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import CoreLocation
import MapboxSearch

struct SuggestionEntity: Identifiable, Equatable, Hashable {
    static func == (lhs: SuggestionEntity, rhs: SuggestionEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let label: String
    let suggestion: PlaceAutocomplete.Suggestion
    
    static func from(dto: SuggestionDTO) -> SuggestionEntity? {
        guard let id = dto.id else {
            return nil
        }
        return .init(id: id, label: "\(dto.suggestion.name), \(dto.suggestion.description ?? "")",  suggestion: dto.suggestion)
    }
}
