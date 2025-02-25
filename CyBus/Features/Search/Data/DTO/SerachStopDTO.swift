//
//  SerachStopDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

struct SearchStopDTO: Codable{
    let id: String
    let tripIds: [String]
    let longitude: Double
    let latitude: Double
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tripIds = "trip_ids"
        case longitude = "longitude"
        case latitude = "latitude"
        case city = "city"
    }
}
