//
//  StaticFilesRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

enum RoutesRepositoryError: Error {
    case fileNotFound
}

class StaticFilesRepository: StaticFilesRepositoryProtocol {
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func fetchData<T>(fileName: String, type: T.Type) async throws -> T? where T : Decodable {
        guard let bundleData = bundle.url(forResource: fileName, withExtension: "json") else {
            throw RoutesRepositoryError.fileNotFound
        }
        let data = try Data(contentsOf: bundleData)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func fetchTrips() async throws -> [TripDTO]? {
        return try await fetchData(fileName: "trips", type: [TripDTO].self)
    }
    
    func fetchShapes() async throws -> [ShapeDTO]? {
        return try await fetchData(fileName: "shapes", type: [ShapeDTO].self)
    }
    
    func fetchRoutes() async throws -> [RouteDTO]? {
        return try await fetchData(fileName: "routes", type: [RouteDTO].self)
    }
    
    func fetchStops() async throws -> [StopDTO]? {
        return try await fetchData(fileName: "stops", type: [StopDTO].self)
    }
    
    func fetchStopTimes() async throws -> [StopTimeDTO]? {
        return try await fetchData(fileName: "stop_times", type: [StopTimeDTO].self)
    }
}
