//
//  BusRoute.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct RouteDTO: Codable  {
    let lineId: String
    let lineName: String
    let routeName: String
    let firstStop: String
    let lastStop: String?
    let direction: String
    let lineLength: String

    enum CodingKeys: String, CodingKey {
        case lineId = "line_id"
        case lineName = "line_name"
        case routeName = "route_name"
        case firstStop = "first_stop"
        case lastStop = "last_stop"
        case direction = "direction"
        case lineLength = "line_length"
    }
}

