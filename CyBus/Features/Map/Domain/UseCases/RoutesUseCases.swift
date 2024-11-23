//
//  RoutesUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 24/08/2024.
//

import Foundation
import CoreLocation
import ComposableArchitecture

class RoutesUseCases: RoutesUseCasesProtocol {
    
    private let repository: RoutesRepositoryProtocol
    
    private var _routes: [RouteDTO] = []
    private var _shapes: [ShapeDTO] = []
    private var _stopTimes: [StopTimeDTO] = []
    private var _stops: [StopDTO] = []
    private var _trips: [TripDTO] = []
    
    var routes: [RouteDTO] {
        get { _routes }
    }
    
    var shapes: [ShapeDTO] {
        get { _shapes }
    }
    
    var stopTimes: [StopTimeDTO] {
        get { _stopTimes }
    }
    
    var stops: [StopDTO] {
        get { _stops }
    }
    
    var trips: [TripDTO] {
        get { _trips }
    }
    
    init(repository: RoutesRepositoryProtocol = RoutesRepository()) {
        self.repository = repository
    }
    
    func getRoute(for routeID: String) -> BusRouteEntity {
        let shapes = _shapes.filter { $0.shapeId == routeID }
        let trip = _trips.first {$0.routeId == routeID }
        let stopTimes = _stopTimes.filter { $0.tripId == trip?.tripId }
        let stopIds = stopTimes.map { $0.stopId }
        let stops = _stops.filter { stopIds.contains($0.stopId) }
        return BusRouteEntity(
            shapes: shapes.map { ShapeEntity(
                id: $0.shapeId,
                position: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees($0.latitude ) ?? 0,
                    longitude: CLLocationDegrees($0.longitude ) ?? 0
                ),
                sequence: Int($0.sequence) ?? 0)
            },
            stops: stops.map { StopEntity(
                id: $0.stopId,
                position: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees($0.latitude ) ?? 0,
                    longitude: CLLocationDegrees($0.longitude ) ?? 0
                )
            )
            }
        )
    }
    
    func fetchRoutes() async throws {
        async let routes = repository.fetchRoutes()
        async let shapes = repository.fetchShapes()
        async let stopTimes = repository.fetchStopTimes()
        async let stops = repository.fetchStops()
        async let trips = repository.fetchTrips()
        
        do {
            let result = try await (routes, shapes, stopTimes, stops, trips)
            _routes = result.0 ?? []
            _shapes = result.1 ?? []
            _stopTimes = result.2 ?? []
            _stops = result.3 ?? []
            _trips = result.4 ?? []
        } catch {
            throw error
        }
    }
    
}

struct RoutesUseCasesKey: DependencyKey {
    static var liveValue: RoutesUseCasesProtocol = RoutesUseCases()
}


extension DependencyValues {
    var routesUseCases: RoutesUseCasesProtocol {
        get { self[RoutesUseCasesKey.self] }
        set { self[RoutesUseCasesKey.self] = newValue }
    }
}
