//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//
import CoreLocation
import Foundation

struct BusEntity: Identifiable, Equatable, Hashable {
    
    static func == (lhs: BusEntity, rhs: BusEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let routeID: String
    let lineName: String
    let position: CLLocationCoordinate2D
    let lineColor: String?
    
    init(id: String, position: CLLocationCoordinate2D, routeID: String, lineName: String, lineColor: String?) {
        self.id = id
        self.routeID = routeID
        self.position = position
        self.lineName = lineName
        self.lineColor = lineColor
    }
}

extension BusEntity {
    
    struct ProximityTo: SortComparator, Hashable {
        var order: SortOrder = .forward
        
        let referencePoint: CLLocationCoordinate2D
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(referencePoint.latitude)
            hasher.combine(referencePoint.longitude)
        }
        
        func compare(_ lhs: BusEntity, _ rhs: BusEntity) -> ComparisonResult {
            let distanceToLHS = lhs.position.distance(to: referencePoint)
            let distanceToRHS = rhs.position.distance(to: referencePoint)
            
            if distanceToLHS == distanceToRHS {
                return .orderedSame
            }
            
            return (distanceToLHS < distanceToRHS) == (order == .forward)
            ? .orderedAscending
            : .orderedDescending
        }
    }
    
}
