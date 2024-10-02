//
//  Trip.swift
//  CyBus
//
//  Created by Vadim Popov on 06/08/2024.
//

import Foundation

struct TripDTO: Codable  {
    let routeId: String
    let serviceId: String
    let tripId: String
    let tripHeadsign: String?
    let tripShortName: String?
    let directionId: String?
    let blockId: String?
    let shapeId: String?
    
    enum CodingKeys: String, CodingKey {
        case routeId = "route_id"
        case serviceId = "service_id"
        case tripId = "trip_id"
        case tripHeadsign = "trip_headsign"
        case tripShortName = "trip_short_name"
        case directionId = "direction_id"
        case blockId = "block_id"
        case shapeId = "shape_id"
    }
}

