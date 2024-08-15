//
//  Stop.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct Stop: Codable, Identifiable {
    let id: String
    let name: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case id = "stop_id"
        case name = "stop_name"
        case latitude = "stop_lat"
        case longitude = "stop_lon"
    }
}
