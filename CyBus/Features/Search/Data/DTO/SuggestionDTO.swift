//
//  SuggestionDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import Foundation

struct SuggestionDTO: Codable {
    let id: Int
    let licence: String
    let osmType: String
    let osmId: Int
    let lat: String
    let lon: String
    let category: String
    let type: String
    let placeRank: Int
    let importance: Double
    let addressType: String
    let name: String
    let displayName: String
    let boundingBox: [String]

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case licence
        case osmType = "osm_type"
        case osmId = "osm_id"
        case lat
        case lon
        case category
        case type
        case placeRank = "place_rank"
        case importance
        case addressType = "addresstype"
        case name
        case displayName = "display_name"
        case boundingBox = "boundingbox"
    }
}
