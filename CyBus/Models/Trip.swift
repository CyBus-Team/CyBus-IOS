//
//  Trip.swift
//  CyBus
//
//  Created by Vadim Popov on 06/08/2024.
//

import Foundation

struct Trip: Codable {
    let route_id: String
    let service_id: String
    let trip_id: String
    let trip_headsign: String?
    let trip_short_name: String?
    let direction_id: String?
    let block_id: String?
    let shape_id: String?
}
