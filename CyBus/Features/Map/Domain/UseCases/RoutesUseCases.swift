//
//  RoutesUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import Factory
import Foundation
import CoreLocation

class RoutesUseCases : RoutesUseCasesProtocol {
    
    @Injected(\.staticFilesUseCases) var staticFilesUseCases: StaticFilesUseCasesProtocol
    
    init(
        staticFilesUseCases: StaticFilesUseCasesProtocol = Container.shared.staticFilesUseCases()
    ) {
        self.staticFilesUseCases = staticFilesUseCases
    }
    
    func getRoute(for routeID: String) -> RouteEntity {
        let shapes = staticFilesUseCases.shapes.filter { $0.shapeId == routeID }
        let trip = staticFilesUseCases.trips.first {$0.routeId == routeID }
        let stopTimes = staticFilesUseCases.stopTimes.filter { $0.tripId == trip?.tripId }
        let stopIds = stopTimes.map { $0.stopId }
        let stops = staticFilesUseCases.stops.filter { stopIds.contains($0.stopId) }
        return RouteEntity(
            routeId: routeID,
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
    
}
