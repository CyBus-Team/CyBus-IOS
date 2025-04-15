//
//  BusDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

struct BusDTO: Codable {
    let label: String
    let latitude: Double
    let longitude: Double
    let bearing: Double
    let startTime: String
    let speedKmPerHour: Double
    let tripID: String
    let routeID: String
    let routeShortName: String
    let routeLongName: String
    let receivedFromBusAt: String

    enum CodingKeys: String, CodingKey {
        case label = "Label"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case bearing = "Bearing"
        case startTime = "StartTime"
        case speedKmPerHour = "SpeedKmPerHour"
        case tripID = "TripID"
        case routeID = "RouteID"
        case routeShortName = "RouteShortName"
        case routeLongName = "RouteLongName"
        case receivedFromBusAt = "ReceivedFromBusAt"
    }
}
