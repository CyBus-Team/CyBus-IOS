//
//  Shape.swift
//  CyBus
//
//  Created by Vadim Popov on 27/07/2024.
//

import Foundation
@_spi(Experimental) import MapboxMaps

struct BusShape: Codable, Identifiable, Hashable {
    let shape_id: String
    let shape_pt_lat: String
    let shape_pt_lon: String
    let shape_pt_sequence: String
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: CLLocationDegrees(shape_pt_lat) ?? 0,
            longitude: CLLocationDegrees(shape_pt_lon) ?? 0
        )
    }
    
    var id: String {
        return "\(shape_id)_\(shape_pt_sequence)"
    }
}
