//
//  BusesUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import CoreLocation
import Factory

enum BusesUseCasesError: Error {
    case routesIsEmpty
}

class BusesUseCases: BusesUseCasesProtocol {
    
    @Injected(\.busesRepository) var repository: BusesRepositoryProtocol
    
    func fetchBuses() async throws -> [BusEntity] {
        do {
            let buses = try await repository.fetchBuses()
            return buses.buses
                .map {
                    BusEntity(
                        id: $0.value.label,
                        routeID:$0.value.routeID,
                        lineName:  $0.value.routeShortName,
                        position: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees($0.value.latitude),
                            longitude: CLLocationDegrees($0.value.longitude)
                        )
                    )
                }
        } catch {
            throw error
        }
    }
    
}
