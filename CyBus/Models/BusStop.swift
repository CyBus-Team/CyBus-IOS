//
//  BusStops.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

struct BusStop: Codable, Identifiable, Hashable {
    var id: String { stop_id }
    
    let stop_id: String
    let stop_name: String
    let stop_lat: String
    let stop_lon: String
}

