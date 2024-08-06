//
//  RouteData.swift
//  CyBus
//
//  Created by Vadim Popov on 06/08/2024.
//

import Foundation

struct RouteData: Identifiable, Hashable {
    var id: String { tripId }
    
    static func == (lhs: RouteData, rhs: RouteData) -> Bool {
        lhs.id == rhs.id
    }
    
    let tripId: String
    let stops: [BusStop]
    let shapes: [BusShape]
}
