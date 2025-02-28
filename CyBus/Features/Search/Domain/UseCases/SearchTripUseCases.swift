//
//  SearchTripUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Foundation
import CoreLocation
import ComposableArchitecture
import MapboxDirections

class SearchTripUseCases: SearchTripUseCasesProtocol {
    
    private let routesUseCases: RoutesUseCasesProtocol
    private let repository: SearchTripRepositoryProtocol
    private let bundle: Bundle
    
    init(
        routesUseCases: RoutesUseCasesProtocol = RoutesUseCases(),
        repository: SearchTripRepositoryProtocol = SearchTripRepositoryLocal(),
        bundle: Bundle = .main
    ) {
        self.routesUseCases = routesUseCases
        self.repository = repository
        self.bundle = bundle
    }
    
    func getNodes(
        for stops: [SearchStopEntity],
        from userLocation: CLLocationCoordinate2D,
        to destionation: CLLocationCoordinate2D
    ) async throws -> [TripNodeEntity] {
        var nodes: [TripNodeEntity] = []
        
        try await routesUseCases.fetchRoutes()
        let routesDTO = routesUseCases.routes
        let tripsDTO = routesUseCases.trips
        
        for stop in stops {
            let tripIds = stop.tripIds
            let routeIds = tripsDTO.filter { tripIds.contains($0.tripId) }.compactMap { $0.routeId }
            let lineName = routesDTO.filter { routeIds.contains($0.lineId) }.first?.lineName ?? ""
            nodes.append(TripNodeEntity(id: stop.id, line: lineName, type: .busStop, location: stop.location))
        }
        
        // From user location to first stop
        guard let firstNode = nodes.first else {
            return nodes
        }
        let walkToFirstPoint = try await getWalkPoints(from: userLocation, to: firstNode.location)
        let startNodes = walkToFirstPoint
            .map {
                TripNodeEntity(
                    id: UUID().uuidString,
                    line: firstNode.line,
                    type: .walk,
                    location: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                )
            }
        nodes.insert(contentsOf: startNodes, at: nodes.startIndex)
        
        // From last stop to destination
        guard let lastStopLocation = stops.last?.location else {
            return nodes
        }
        let walkToDestination = try await getWalkPoints(from: lastStopLocation, to: destionation)
        let lastNodes = walkToDestination
            .map {
                TripNodeEntity(
                    id: UUID().uuidString,
                    line: firstNode.line,
                    type: .walk,
                    location: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                )
            }
        nodes.insert(contentsOf: lastNodes, at: nodes.endIndex)
        
        return nodes
    }
    
    func getWalkPoints(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [CLLocationCoordinate2D] {
        let walkPoints = [
            Waypoint(coordinate: from),
            Waypoint(coordinate: to)
        ]
        
        let options = RouteOptions(waypoints: walkPoints, profileIdentifier: .walking)
        
        guard let mapBoxAccessToken = bundle.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            throw SearchTripUseCasesError.apiNotAvailable
        }
        
        let directions = Directions(accessToken: mapBoxAccessToken)
        return try await withCheckedThrowingContinuation { continuation in
            directions.calculate(options) { (waypoints, routes, error) in
                guard error != nil || waypoints != nil else {
                    continuation.resume(throwing: error ?? SearchTripUseCasesError.apiNotAvailable)
                    return
                }
                continuation.resume(returning: routes?.first?.coordinates ?? [])
            }
        }

    }
    
    func nearestCity(to coordinate: CLLocationCoordinate2D) throws -> String? {
        do {
            let cities = try repository.getCities()
            return cities.min(by: {
                let dist1 = pow($0.latitude - coordinate.latitude, 2) + pow($0.longitude - coordinate.longitude, 2)
                let dist2 = pow($1.latitude - coordinate.latitude, 2) + pow($1.longitude - coordinate.longitude, 2)
                return dist1 < dist2
            })?.name
        } catch {
            debugPrint(error)
            throw SearchTripUseCasesError.cityNotFound
        }
    }
    
    func getStops(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [SearchStopEntity] {
        do {
            let tripsDTO = try await repository.getTrips()
            debugPrint("tripsDTO \(tripsDTO.count)")
            let stopsDTO = try await repository.getStops()
            debugPrint("stopsDTO \(stopsDTO.count)")
            
            guard let city = try nearestCity(to: from) else {
                throw SearchTripUseCasesError.cityNotFound
            }
            debugPrint("City \(city)")
            
            let tripsEntities = tripsDTO.map { SearchTripEntity.from(dto: $0) }.filter {$0.city.elementsEqual(city)}
            debugPrint("tripsEntities \(tripsEntities.count)")
            let stopsEntities = stopsDTO.map { SearchStopEntity.from(dto: $0) }.filter {$0.city.elementsEqual(city)}
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
