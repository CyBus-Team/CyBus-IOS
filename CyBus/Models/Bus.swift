//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation

struct Bus: Identifiable {
    let id: String
    let currentLocation: MapLocation
    let route: Route?
}
