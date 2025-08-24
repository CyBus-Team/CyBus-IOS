//
//  RouteDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 23/08/2025.
//

struct RouteDTO: Codable {
    let stops: [StopDTO]
    let firstStop: StopDTO
    let lastStop: StopDTO
    let shape: [ShapePointDTO]
}

struct StopDTO: Codable {
    let description: String
    let lat: Double
    let lon: Double
}

struct ShapePointDTO: Codable {
    let lat: Double
    let lon: Double
}
