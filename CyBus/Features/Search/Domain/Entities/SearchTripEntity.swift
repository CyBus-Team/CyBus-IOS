//
//  TripPatternEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 20/04/2025.
//

import Foundation
import CoreLocation
import SwiftUICore

enum LegMode : Equatable {
    case foot
    case bus
    case unowned (String)
}

struct SearchTripEntity: Identifiable, Equatable {
    
    static func == (lhs: SearchTripEntity, rhs: SearchTripEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let duration: Duration
    let distance: Double
    let formattedDistance: String
    let startTime: Date?
    let endTime: Date?
    let legs: [LegEntity]
}

struct LegEntity: Identifiable, Equatable {
    
    static func == (lhs: LegEntity, rhs: LegEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let points: [CLLocationCoordinate2D]
    let mode: LegMode
    let line: String?
    let lineColor: Color
}

