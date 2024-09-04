//
//  GeoDataRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

protocol RoutesRepositoryProtocol {
    
    func fetchData<T: Decodable>(fileName: String, type: T.Type) async throws -> T?
    func fetchTrips() async throws -> [TripDTO]?
    func fetchShapes() async throws -> [ShapeDTO]?
    func fetchRoutes() async throws -> [RouteDTO]?
    func fetchStops() async throws -> [StopDTO]?
    func fetchStopTimes() async throws -> [StopTimeDTO]?
    
}
