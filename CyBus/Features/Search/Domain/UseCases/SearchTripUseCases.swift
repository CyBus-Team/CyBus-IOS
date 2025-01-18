//
//  SearchTripUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Foundation
import CoreLocation
//import ComposableArchitecture

//class BusRouteFinder {
//    private let stops: [RouteStopEntity]
//    private let routes: [RouteEntity]
//    
//    init(stops: [RouteStopEntity], routes: [RouteEntity]) {
//        self.stops = stops
//        self.routes = routes
//    }
//
//}

protocol SearchTripUseCasesProtocol {
    func findTrip(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws
}

class SearchTripUseCases: SearchTripUseCasesProtocol {
    
    private let routesUseCases: RoutesUseCasesProtocol
    private let repository: SearchTripRepositoryProtocol
    
    init(routesUseCases: RoutesUseCasesProtocol = RoutesUseCases(), repository: SearchTripRepositoryProtocol = SearchTripRepositoryLocal()) {
        self.routesUseCases = routesUseCases
        self.repository = repository
    }
    
    func findTrip(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws {
        do {
            
            let trips = try await repository.getTrips()
            let stops = try await repository.getStops()
            
            let allTrips = trips.map {
                RouteEntity(
                    id: $0.id,
                    stops: $0.stops
                        .map {
                            RouteStopEntity(
                                id: $0.id,
                                location: CLLocationCoordinate2D(latitude: $0.location.latitude, longitude: $0.location.longitude),
                                routeIds: $0.tripIds
                            )
                        },
                    shapes: []
                )
            }
            let allStops = allRoutes
                .map { $0.stops }
                .filter { $0 }
            
            let routeFinder = BusRouteFinder(stops: allStops, routes: allTrips)
            if let route = routeFinder.findRoute(from: from, to: to) {
                print("Route found: \(route.map { $0.id })")
            } else {
                print("No route found.")
            }
        } catch {
            print(error)
        }
        
    }
    
    func findRoute(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> [RouteStopEntity]? {
        print("Finding route from \(start) to \(destination)")
        
        // Find the closest stops to the start and destination
        guard let startStop = findClosestStop(to: start) else {
            print("No start stop found near \(start)")
            return nil
        }
        guard let endStop = findClosestStop(to: destination) else {
            print("No destination stop found near \(destination)")
            return nil
        }
        
        print("Start stop: \(startStop.id), End stop: \(endStop.id)")
        
        // Perform a breadth-first search (BFS) to find the route
        return bfs(from: startStop, to: endStop)
    }
    
    func findClosestStop(to location: CLLocationCoordinate2D) -> RouteStopEntity? {
        stops.min(by: { $0.location.distance(to: location) < $1.location.distance(to: location) })
    }
    
    func bfs(from start: RouteStopEntity, to destination: RouteStopEntity) -> [RouteStopEntity]? {
        var queue: [[RouteStopEntity]] = [[start]]
        var visited: Set<String> = [start.id]
        
        while !queue.isEmpty {
            let path = queue.removeFirst()
            guard let currentStop = path.last else { continue }
            
            // Check if we reached the destination
            if currentStop.id == destination.id {
                print("Found path: \(path.map { $0.id })")
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
        
        print("No path found from \(start.id) to \(destination.id)")
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
