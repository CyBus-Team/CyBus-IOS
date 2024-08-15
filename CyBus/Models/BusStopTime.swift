//
//  StopTime.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import Foundation

struct BusStopTime: Codable {
    let trip_id: String
    let arrival_time: String
    let departure_time: String
    let stop_id: String
    let stop_sequence: String
}
