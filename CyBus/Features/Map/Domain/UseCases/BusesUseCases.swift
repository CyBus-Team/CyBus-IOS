//
//  MapUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import CoreLocation

enum BusesUseCasesError: Error {
    case gftsServiceNotFound
    case routesIsEmpty
}


class BusesUseCases: BusesUseCasesProtocol {
    
    private let repository: BusesRepositoryProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    
    private var gftsURL: URL?
    
    init(repository: BusesRepositoryProtocol, routesUseCases: RoutesUseCasesProtocol) {
        self.repository = repository
        self.routesUseCases = routesUseCases
    }
    
    func fetchServiceUrl() throws {
        do {
            self.gftsURL = try repository.getServiceUrl()
        } catch {
            throw error
        }
    }
    
    func fetchBuses() async throws -> [BusEntity] {
        guard let url = gftsURL else {
            throw BusesUseCasesError.gftsServiceNotFound
        }
        do {
            let feedBuses = try await repository.fetchBuses(url: url)
            let buses = feedBuses.compactMap { entity -> BusEntity? in
                if !entity.hasVehicle {
                    return nil
                }
                if let route = routesUseCases.routes.first(where: { $0.lineId == entity.vehicle.trip.routeID }) {
                    let bus = BusEntity(
                        id: entity.vehicle.vehicle.id,
                        position: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(entity.vehicle.position.latitude),
                            longitude: CLLocationDegrees(entity.vehicle.position.longitude)
                        ),
                        lineName: route.lineName,
                        routeID: entity.vehicle.trip.routeID
                    )
                    return bus
                } else {
                    return nil
                }
            }
            return buses
        } catch {
            switch error {
            case let error as BusesRepositoryError:
                throw error
            default:
                throw error
            }
        }
    }
    
}
