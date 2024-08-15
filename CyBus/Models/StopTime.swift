//
//  StopTimes.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct StopTime: Codable, Identifiable {
    let id: String
    let arrivalTime: String
    let departureTime: String
    let stopId: String
    let stopSequence: String

    enum CodingKeys: String, CodingKey {
        case id = "trip_id"
        case arrivalTime = "arrival_time"
        case departureTime = "departure_time"
        case stopId = "stop_id"
        case stopSequence = "stop_sequence"
    }
}
