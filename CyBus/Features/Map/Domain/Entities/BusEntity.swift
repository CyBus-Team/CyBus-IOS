//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//
import CoreLocation
import Foundation

struct BusEntity: Identifiable, Equatable {
    
    static func == (lhs: BusEntity, rhs: BusEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let routeID: String
    let lineName: String
    let position: CLLocationCoordinate2D

}
