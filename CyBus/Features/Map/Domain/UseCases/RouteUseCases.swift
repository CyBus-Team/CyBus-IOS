//
//  RouteUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import FactoryKit
import CoreLocation

class RouteUseCases : RouteUseCasesProtocol {
    
    @Injected(\.routeRepository) var repository: RouteRepositoryProtocol
    
    func getRoute(for tripID: String) async throws -> RouteEntity {
        do {
            let dto = try await repository.fetchRoute(for: tripID)
            return RouteEntity(
                stops: dto.stops.map {
                    StopEntity(
                        description: $0.description,
                        position: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon),
                    )
                },
                firstStop: StopEntity(
                    description: dto.firstStop.description,
                    position: CLLocationCoordinate2D(latitude: dto.firstStop.lat, longitude: dto.firstStop.lon)
                ),
                lastStop: StopEntity(
                    description: dto.lastStop.description,
                    position: CLLocationCoordinate2D(latitude: dto.lastStop.lat, longitude: dto.lastStop.lon)
                ),
                shape: dto.shape.map {
                    ShapeEntity(
                        position: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon),
                    )
                },
                arrivalTime: dto.arrivalTime,
                departureTime: dto.departureTime,
                routeName: dto.routeName,
                routeNumber: dto.routeNumber,
            )
        } catch {
            throw error
        }
    }
    
}
