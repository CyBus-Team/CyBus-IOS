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
    
    func fetchClusters(from buses: [BusEntity], withDistance distance: Distance) -> [BusClusterEntity] {
        // If the map is zoomed in close (distance < 5 km), skip clustering and show individual buses
        guard distance > 5000 else {
            return buses.map { BusClusterEntity(buses: [$0]) }
        }
        
        // Divide map into a virtual grid — the divisor controls cluster granularity
        // 700_000 is a scaling constant that affects cluster density:
        //   - Larger divisor = more clusters
        //   - Smaller divisor = fewer, bigger clusters
        let gridSize = distance / 700_000

        var clusters: [String: [BusEntity]] = [:]
        
        for bus in buses {
            let key = "\(Int(bus.position.latitude / gridSize))_\(Int(bus.position.longitude / gridSize))"
            clusters[key, default: []].append(bus)
        }
        
        return clusters.values.map { BusClusterEntity(buses: $0) }
    }
    
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
