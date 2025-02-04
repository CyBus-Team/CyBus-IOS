//
//  TripNodeEntity.swift
//  CyBus
//
//  Created by Vadim Popov on 10/01/2025.
//

import Foundation
import CoreLocation

enum NodeType {
    case busStop
    case walk
}

struct TripNodeEntity : Equatable, Identifiable {
    let id: String
    let line: String
    let type: NodeType
    let location: CLLocationCoordinate2D
}
