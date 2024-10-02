//
//  Stop.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct StopDTO: Codable  {
    let stopId: String
    let code: String
    let name: String
    let description: String?
    let latitude: String
    let longitude: String
    let zoneID: String

    enum CodingKeys: String, CodingKey {
        case stopId = "stop_id"
        case code = "stop_code"
        case name = "stop_name"
        case description = "stop_desc"
        case latitude = "stop_lat"
        case longitude = "stop_lon"
        case zoneID = "zone_id"
    }
}
