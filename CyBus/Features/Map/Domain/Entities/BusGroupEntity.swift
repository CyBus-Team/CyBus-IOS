//
//  BusGroupEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 27/11/2024.
//

import CoreLocation

struct BusGroupEntity: Identifiable, Equatable {
    static func == (lhs: BusGroupEntity, rhs: BusGroupEntity) -> Bool {
        lhs.position == rhs.position
    }
    
    let id: String
    let position: CLLocationCoordinate2D
    let buses: [BusEntity]
    
    init(id: String, position: CLLocationCoordinate2D, buses: [BusEntity]) {
        self.id = id
        self.position = position
        self.buses = buses
    }
}

extension BusGroupEntity {
    
    var uniqueLines: [String] {
        var uniqies = Set<String>()
        return allLines.filter { uniqies.insert($0).inserted }
    }
    
    var allLines: [String] {
        buses.map{$0.lineName}
    }
    
    var lineColor: String? {
        buses.count > 1 ? nil : buses.first?.lineColor
    }
    
}
