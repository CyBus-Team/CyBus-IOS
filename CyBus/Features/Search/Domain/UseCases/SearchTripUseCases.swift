//
//  SearchTripUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Foundation
import CoreLocation
import ComposableArchitecture

class SearchTripUseCases: SearchTripUseCasesProtocol {
    
    private let routesUseCases: RoutesUseCasesProtocol
    private let repository: SearchTripRepositoryProtocol
    
    init(
        routesUseCases: RoutesUseCasesProtocol = RoutesUseCases(),
        repository: SearchTripRepositoryProtocol = SearchTripRepositoryLocal()
    ) {
        self.routesUseCases = routesUseCases
        self.repository = repository
    }
    
    func getNodes(from stops: [SearchStopEntity]) async throws -> [TripNodeEntity] {
        var result: [TripNodeEntity] = []
        
        for stop in stops.indices {
            result.append(TripNodeEntity(id: stops[stop].id, type: .busStop, location: stops[stop].location))
        }
        
        return result
    }
    
    func getStops(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [SearchStopEntity] {
        do {
            let tripsDTO = try await repository.getTrips()
            debugPrint("tripsDTO \(tripsDTO.count)")
            let stopsDTO = try await repository.getStops()
            debugPrint("stopsDTO \(stopsDTO.count)")
            let shapes = routesUseCases.shapes
            debugPrint("shapes \(shapes.count)")
            
            let tripsEntities = tripsDTO
                .map {
                    SearchTripEntity.from(
                        dto: $0,
                        shapes: shapes.map { TripShapeEntity.from(dto: $0) }
                    )
                }
            debugPrint("tripsEntities \(tripsEntities.count)")
            let stopsEntities = stopsDTO.map { SearchStopEntity.from(dto: $0) }
            debugPrint("stopsEntities \(stopsEntities.count)")
            
            debugPrint("Finding route from \(from) to \(to)")
            
            // Find the closest stops to the start and destination
            guard let startStop = findClosestStop(to: from, stops: stopsEntities) else {
                debugPrint("No start stop found near \(from)")
                throw SearchTripUseCasesError.noStartStopFound
            }
            guard let endStop = findClosestStop(to: to, stops: stopsEntities) else {
                debugPrint("No destination stop found near \(to)")
                throw SearchTripUseCasesError.noEndStopFound
            }
            
            debugPrint("Start stop: \(startStop.id), End stop: \(endStop.id)")
            
            // Perform a breadth-first search (BFS) to find the route
            let stopIds = breadthFirstSearch(from: startStop, to: endStop, trips: tripsEntities)
            
            guard let stopIds else {
                debugPrint("No route found")
                throw SearchTripUseCasesError.noRouteFound
            }
            
            return stopIds.compactMap { stopId in
                stopsEntities.first { $0.id == stopId }
            }
            
        } catch {
            debugPrint(error)
            throw SearchTripUseCasesError.noRouteFound
        }
        
    }
    
    func findClosestStop(to location: CLLocationCoordinate2D, stops: [SearchStopEntity]) -> SearchStopEntity? {
        stops.min(by: { $0.location.distance(to: location) < $1.location.distance(to: location) })
    }
    
    func breadthFirstSearch(
        from start: SearchStopEntity,
        to destination: SearchStopEntity,
        trips: [SearchTripEntity]
    ) -> [SearchStopEntityID]? {
        var queue: [[SearchStopEntityID]] = [[start.id]]
        var visited: Set<String> = [start.id]
        
        while !queue.isEmpty {
            let path = queue.removeFirst()
            guard let currentStop = path.last else { continue }
            
            // Check if we reached the destination
            if currentStop == destination.id {
                debugPrint("Found path: \(path.map { $0 })")
                return path
            }
            
            // Explore connected stops via routes
            for trip in trips where trip.stopsIds.contains(where: { $0 == currentStop }) {
                for stop in trip.stopsIds where !visited.contains(stop) {
                    visited.insert(stop)
                    queue.append(path + [stop])
                }
            }
        }
        
        debugPrint("No path found from \(start.id) to \(destination.id)")
        return nil
    }
    
}

struct SearchTripUseCasesKey: DependencyKey {
    static var liveValue: SearchTripUseCasesProtocol = SearchTripUseCases()
}

extension DependencyValues {
    var addressPathUseCases: SearchTripUseCasesProtocol {
        get { self[SearchTripUseCasesKey.self] }
        set { self[SearchTripUseCasesKey.self] = newValue }
    }
}

private extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let deltaLat = self.latitude - other.latitude
        let deltaLon = self.longitude - other.longitude
        return sqrt(deltaLat * deltaLat + deltaLon * deltaLon)
    }
}
