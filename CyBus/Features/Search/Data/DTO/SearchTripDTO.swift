//
//  SearchTripDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

struct SearchTripDTO: Codable{
    let id: String
    let stopsIds: [String]
    let shapes: [TripShapeDTO]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case stopsIds = "stop_ids"
        case shapes = "shapes"
    }
}

struct TripShapeDTO: Codable {
    let id: String
    let longitude: Double
    let latitude: Double
    let sequence: Int
}
