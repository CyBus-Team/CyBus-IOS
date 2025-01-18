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
    
    init(routesUseCases: RoutesUseCasesProtocol = RoutesUseCases(), repository: SearchTripRepositoryProtocol = SearchTripRepositoryLocal()) {
        self.routesUseCases = routesUseCases
        self.repository = repository
    }
    
    func findTrip(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [TripNodeEntity] {
        do {
            
            let tripsDTO = try await repository.getTrips()
            let stopsDTO = try await repository.getStops()
            
            let tripsEntities = tripsDTO.map { SearchTripEntity.from(dto: $0) }
            let stopsEntities = stopsDTO.map { SearchStopEntity.from(dto: $0) }
            
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
            let stops = breadthFirstSearch(from: startStop, to: endStop, trips: tripsEntities, stops: stopsEntities)
            
            guard let tripStops = stops else {
                debugPrint("No route found")
                throw SearchTripUseCasesError.noRouteFound
            }
            
            var result: [TripNodeEntity] = []
            for stop in tripStops {
                result.append(TripNodeEntity(type: .busStop, location: stop.location))
            }
            return result
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
        trips: [SearchTripEntity],
        stops: [SearchStopEntity]
    ) -> [SearchStopEntity]? {
        var queue: [[SearchStopEntity]] = [[start]]
        var visited: Set<String> = [start.id]
        
        while !queue.isEmpty {
            let path = queue.removeFirst()
            guard let currentStop = path.last else { continue }
            
            // Check if we reached the destination
            if currentStop.id == destination.id {
                debugPrint("Found path: \(path.map { $0.id })")
                return path
            }
            
            // Explore connected stops via routes
            for route in trips where route.stopsIds.contains(where: { $0 == currentStop.id }) {
                for stop in route.stopsIds where !visited.contains(stop) {
                    visited.insert(stop)
                    let detailedStop = stops.first(where: { $0.id == stop })
                    queue.append(path + [detailedStop!])
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

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let deltaLat = self.latitude - other.latitude
        let deltaLon = self.longitude - other.longitude
        return sqrt(deltaLat * deltaLat + deltaLon * deltaLon)
    }
}
