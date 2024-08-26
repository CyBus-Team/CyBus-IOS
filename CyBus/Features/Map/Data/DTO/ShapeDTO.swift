//
//  Shape.swift
//  CyBus
//
//  Created by Vadim Popov on 15/08/2024.
//

import Foundation

struct ShapeDTO: Codable  {
    let shapeId: String
    let latitude: String
    let longitude: String
    let sequence: String

    enum CodingKeys: String, CodingKey {
        case shapeId = "shape_id"
        case latitude = "shape_pt_lat"
        case longitude = "shape_pt_lon"
        case sequence = "shape_pt_sequence"
    }
}
