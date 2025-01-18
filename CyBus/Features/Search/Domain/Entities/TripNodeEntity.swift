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

struct TripNodeEntity : Equatable {
    let type: NodeType
    let location: CLLocationCoordinate2D
}
