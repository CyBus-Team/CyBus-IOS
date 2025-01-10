//
//  AddressPathUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Foundation
import CoreLocation
import ComposableArchitecture

class BusRouteFinder {
    private let stops: [RouteStopEntity]
    private let routes: [RouteEntity]
    
    init(stops: [RouteStopEntity], routes: [RouteEntity]) {
        self.stops = stops
        self.routes = routes
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
    
    private func findClosestStop(to location: CLLocationCoordinate2D) -> RouteStopEntity? {
        stops.min(by: { $0.location.distance(to: location) < $1.location.distance(to: location) })
    }
    
    private func bfs(from start: RouteStopEntity, to destination: RouteStopEntity) -> [RouteStopEntity]? {
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

// MARK: - My implementation

protocol AddressPathUseCasesProtocol {
    func findPath(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws
}

class AdressPathUseCases: AddressPathUseCasesProtocol {
    
    private let routesUseCases: RoutesUseCasesProtocol
    
    init(routesUseCases: RoutesUseCasesProtocol = RoutesUseCases()) {
        self.routesUseCases = routesUseCases
    }
    
    func findPath(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws {
        do {
            debugPrint("fectching routes...")
            try await routesUseCases.fetchRoutes()
            let routesDTO = routesUseCases.routes
            let stopsDTO = routesUseCases.stops
            let tripsDTO = routesUseCases.trips
            let stopTimesDTO = routesUseCases.stopTimes
            // Get all stops entities
            var allStops: [RouteStopEntity] = []
            let uniqueTrips = Set(tripsDTO.map(\..tripId))
            for tripIndex in uniqueTrips.indices {
                let tripId = uniqueTrips[tripIndex]
                print("Processing trip \(tripIndex) of \(uniqueTrips.count)")
                let stopIds = stopTimesDTO
                    .filter { $0.tripId == tripId }
                    .map { $0.stopId }
                let stops = stopsDTO
                    .filter { stopIds.contains($0.stopId) }
                    .map {
                        RouteStopEntity(
                            id: $0.stopId,
                            location: CLLocationCoordinate2D(
                                latitude: CLLocationDegrees($0.latitude ) ?? 0,
                                longitude: CLLocationDegrees($0.longitude ) ?? 0
                            ),
                            routeIds: routesDTO
                                .filter { $0.lineId == tripId }
                                .map { $0.lineId }
                        )
                    }
                print("\(stops.count) stops")
                allStops += stops
            }
            print("all stops: \(allStops.count)")
            var allRoutes: [RouteEntity] = []
            for route in routesDTO {
                let stops = allStops.filter { $0.routeIds.contains(route.lineId) }
                allRoutes.append(RouteEntity(id: route.lineId, stops: stops, shapes: []))
            }
            print("All stops: \(allStops.count)")
            print("All routes: \(allRoutes.count)")
            //
            
            let routeFinder = BusRouteFinder(stops: allStops, routes: allRoutes)
            if let route = routeFinder.findRoute(from: from, to: to) {
                print("Route found: \(route.map { $0.id })")
            } else {
                print("No route found.")
            }
        } catch {
            print(error)
        }
        
    }
    
}

struct AddressPathUseCasesKey: DependencyKey {
    static var liveValue: AddressPathUseCasesProtocol = AdressPathUseCases()
}

extension DependencyValues {
    var addressPathUseCases: AddressPathUseCasesProtocol {
        get { self[AddressPathUseCasesKey.self] }
        set { self[AddressPathUseCasesKey.self] = newValue }
    }
}

// MARK: - Mock Data

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let deltaLat = self.latitude - other.latitude
        let deltaLon = self.longitude - other.longitude
        return sqrt(deltaLat * deltaLat + deltaLon * deltaLon)
    }
}

let mockStops = [
    RouteStopEntity(id: "A", location: CLLocationCoordinate2D(latitude: 0, longitude: 0), routeIds: ["1"]),
    RouteStopEntity(id: "B", location: CLLocationCoordinate2D(latitude: 1, longitude: 1), routeIds: ["1", "2"]),
    RouteStopEntity(id: "C", location: CLLocationCoordinate2D(latitude: 2, longitude: 2), routeIds: ["2"]),
    RouteStopEntity(id: "D", location: CLLocationCoordinate2D(latitude: 3, longitude: 3), routeIds: ["2", "3"]),
    RouteStopEntity(id: "E", location: CLLocationCoordinate2D(latitude: 4, longitude: 4), routeIds: ["3"]),
]

let mockRoutes = [
    RouteEntity(id: "1", stops: [mockStops[0], mockStops[1]], shapes: []),
    RouteEntity(id: "2", stops: [mockStops[1], mockStops[2], mockStops[3]], shapes: []),
    RouteEntity(id: "3", stops: [mockStops[3], mockStops[4]], shapes: []),
]
