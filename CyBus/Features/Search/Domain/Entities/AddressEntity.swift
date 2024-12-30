//
//  AddressEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import CoreLocation

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
}
