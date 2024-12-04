//
//  MapUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import CoreLocation
import ComposableArchitecture
import SwiftUI

enum BusesUseCasesError: Error {
    case gftsServiceNotFound
    case routesIsEmpty
}

class BusesUseCases: BusesUseCasesProtocol {
    
    private let repository: BusesRepositoryProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    
    private var gftsURL: URL?
    @Environment(\.theme) var theme
    
    init(repository: BusesRepositoryProtocol = BusesRepository(), routesUseCases: RoutesUseCasesProtocol = RoutesUseCases()) {
        self.repository = repository
        self.routesUseCases = routesUseCases
    }
    
    func fetchServiceUrl() async throws {
        do {
            self.gftsURL = try repository.getServiceUrl()
            try await routesUseCases.fetchRoutes()
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
            let lineColors = try repository.getLineColors()
            
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
                        routeID: entity.vehicle.trip.routeID,
                        lineName: route.lineName,
                        lineColor: lineColors[route.lineName]
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

func blabla(a: Int = 1) {
    
}

struct BusesUseCasesKey: DependencyKey {
    static var liveValue: BusesUseCasesProtocol = BusesUseCases()
}


extension DependencyValues {
    var busesUseCases: BusesUseCasesProtocol {
        get { self[BusesUseCasesKey.self] }
        set { self[BusesUseCasesKey.self] = newValue }
    }
}
