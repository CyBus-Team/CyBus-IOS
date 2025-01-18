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
            
            let trips = try await repository.getTrips()
            let stops = try await repository.getStops()
            
            debugPrint("Finding route from \(from) to \(to)")
            
            // Find the closest stops to the start and destination
            guard let startStop = findClosestStop(to: from) else {
                debugPrint("No start stop found near \(from)")
                throw SearchTripUseCasesError.noStartStopFound
            }
            guard let endStop = findClosestStop(to: to) else {
                debugPrint("No destination stop found near \(to)")
                throw SearchTripUseCasesError.noEndStopFound
            }
            
            debugPrint("Start stop: \(startStop.id), End stop: \(endStop.id)")
            
            // Perform a breadth-first search (BFS) to find the route
            let res = bfs(from: startStop, to: endStop)

//            if let route = findRoute(from: from, to: to) {
//                print("Route found: \(route.map { $0.id })")
//            } else {
//                print("No route found.")
//            }
        } catch {
            print(error)
        }
        
    }
    
    func findClosestStop(to location: CLLocationCoordinate2D) -> SearchStopDTO? {
        stops.min(by: { $0.location.distance(to: location) < $1.location.distance(to: location) })
    }
    
    func bfs(from start: SearchStopDTO, to destination: SearchStopDTO) -> [SearchStopDTO]? {
        var queue: [[RouteStopEntity]] = [[start]]
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
            for route in routes where route.stops.contains(where: { $0.id == currentStop.id }) {
                for stop in route.stops where !visited.contains(stop.id) {
                    visited.insert(stop.id)
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

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let deltaLat = self.latitude - other.latitude
        let deltaLon = self.longitude - other.longitude
        return sqrt(deltaLat * deltaLat + deltaLon * deltaLon)
    }
}
