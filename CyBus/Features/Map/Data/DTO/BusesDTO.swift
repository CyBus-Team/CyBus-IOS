//
//  BusDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Foundation

struct BusesDTO: Codable  {
    let busCount: Int
    let buses: [String: BusDTO]
    
    enum CodingKeys: String, CodingKey {
        case busCount = "BusCount"
        case buses = "Buses"
    }
}

