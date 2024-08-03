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
        lhs.id == rhs.id
    }
    
    let id: String
    let location: CLLocationCoordinate2D
    let route: Route
}
