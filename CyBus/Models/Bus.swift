//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct Bus: Identifiable, Equatable {
    static func == (lhs: Bus, rhs: Bus) -> Bool {
        lhs.route.lineID == rhs.route.lineID && lhs.route.routeName == rhs.route.routeName
    }
    
    let id: String
    let location: CLLocationCoordinate2D
    let route: Route
}
