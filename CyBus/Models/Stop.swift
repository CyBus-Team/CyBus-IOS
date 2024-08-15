//
//  Stop.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct Stop: Codable, Identifiable {
    let id: String        // stop_id
    let code: String      // stop_code
    let name: String      // stop_name
    let description: String // stop_desc
    let latitude: Double  // stop_lat
    let longitude: Double // stop_lon
    let zoneID: String    // zone_id

    enum CodingKeys: String, CodingKey {
        case id = "stop_id"
        case code = "stop_code"
        case name = "stop_name"
        case description = "stop_desc"
        case latitude = "stop_lat"
        case longitude = "stop_lon"
        case zoneID = "zone_id"
    }
}
