//
//  StaticFilesRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Foundation

protocol StaticFilesRepositoryProtocol {
    
    func fetchData<T: Decodable>(fileName: String, type: T.Type) async throws -> T?
    func fetchTrips() async throws -> [TripDTO]?
    func fetchShapes() async throws -> [ShapeDTO]?
    func fetchRoutes() async throws -> [RouteDTO]?
    func fetchStops() async throws -> [StopDTO]?
    func fetchStopTimes() async throws -> [StopTimeDTO]?
    
}
