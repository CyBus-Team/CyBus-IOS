//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation

struct Bus: Codable, Identifiable {
    let id: String
    let route: String
    let currentLocation: MapLocation
}
