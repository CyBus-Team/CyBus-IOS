//
//  SuggestionDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import Foundation

struct SuggestionDTO: Codable {
    let id: Int
    let name: String
    let address: String
    let lat: Double
    let lon: Double
    let source: String
}
