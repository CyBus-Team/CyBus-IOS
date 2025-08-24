//
//  BusesUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import CoreLocation
import FactoryKit

class BusesUseCases: BusesUseCasesProtocol {
    private let clusteringThreshold: Distance = 50_000
    
    @Injected(\.busesRepository) var repository: BusesRepositoryProtocol
    
    func fetchClusters(from buses: [BusEntity], withDistance distance: Distance) -> [BusClusterEntity] {
        // If the map is zoomed in close (distance < 5 km), skip clustering and show individual buses
        guard distance > clusteringThreshold else {
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
        
        return clusters.values.map { BusClusterEntity( buses: $0) }
    }
    
    func fetchBuses() async throws -> [BusEntity] {
        do {
            let buses = try await repository.fetchBuses()
            return buses.map { BusEntity.from(dto: $0) }
        } catch {
            throw error
        }
    }
    
}
