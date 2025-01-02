//
//  AddressEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import CoreLocation
import MapboxSearch

struct AddressEntity: Identifiable, Equatable, Hashable {
    static func == (lhs: AddressEntity, rhs: AddressEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let label: String
    let location: CLLocationCoordinate2D
    let suggestion: PlaceAutocomplete.Suggestion
    
    static func from(dto: AddressDTO) -> AddressEntity? {
        guard let id = dto.id,
              let location = dto.suggestion.coordinate
        else {
            return nil
        }
        return .init(id: id, label: dto.suggestion.name, location: location, suggestion: dto.suggestion)
    }
}
