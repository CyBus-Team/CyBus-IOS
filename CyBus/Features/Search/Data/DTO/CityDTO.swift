
//
//  CityDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 25/02/2025.
//

struct CityDTO: Codable {
    let name: String
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case longitude = "longitude"
        case latitude = "latitude"
    }
}
