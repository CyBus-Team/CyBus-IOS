//
//  BusDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

struct BusDTO: Codable {
    let vehicleId: String
    let routeId: String
    let label: String
    let latitude: Double
    let longitude: Double
    let timestamp: TimestampDTO
    let shortLabel: String

    enum CodingKeys: String, CodingKey {
        case vehicleId
        case routeId
        case label
        case latitude
        case longitude
        case timestamp
        case shortLabel
    }
}

struct TimestampDTO: Codable {
    let low: Int
    let high: Int
    let unsigned: Bool
}
