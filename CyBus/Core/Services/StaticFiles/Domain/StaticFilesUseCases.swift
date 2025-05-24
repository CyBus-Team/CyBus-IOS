//
//  StaticFilesUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 24/08/2024.
//

import Foundation
import CoreLocation
import ComposableArchitecture
import FactoryKit

class StaticFilesUseCases: StaticFilesUseCasesProtocol {
    
    @Injected(\.staticFilesRepository) var repository: StaticFilesRepositoryProtocol
    
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
    
    func fetch() async throws {
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
