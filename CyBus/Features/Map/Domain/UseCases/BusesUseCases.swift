//
//  MapUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import CoreLocation
import ComposableArchitecture

enum BusesUseCasesError: Error {
    case gftsServiceNotFound
    case routesIsEmpty
}

class BusesUseCases: BusesUseCasesProtocol {
    
    private let repository: BusesRepositoryProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    
    private var googleFeedTrasportServiceURL: URL?
    
    init(repository: BusesRepositoryProtocol = BusesRepository(), routesUseCases: RoutesUseCasesProtocol = RoutesUseCases()) {
        self.repository = repository
        self.routesUseCases = routesUseCases
    }
    
    func group(buses: [BusEntity], by distance: Double) async throws -> [BusGroupEntity] {
        guard !buses.isEmpty else { return [] }
        let referencePoint = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let proximityComparator = BusEntity.ProximityTo(order: .forward, referencePoint: referencePoint)
        let sorted = buses.sorted(using: proximityComparator)
        var result : [[BusEntity]] = []
        var currentGroup: [BusEntity] = [sorted.first!]
        
        for index in 1..<sorted.count {
            let value = sorted[index]
            let prevDistance = value.position.distance(to: sorted[index - 1].position)
            if prevDistance.isLess(than: distance) {
                currentGroup.append(value)
            } else {
                result.append(currentGroup)
                currentGroup = [value]
            }
        }
        
        return result.map{ BusGroupEntity(id: $0.map{ $0.id }.joined(), position: $0.first!.position, buses: $0) }
    }
    
    func fetchServiceUrl() async throws {
        do {
            self.googleFeedTrasportServiceURL = try repository.getServiceUrl()
            try await routesUseCases.fetchRoutes()
        } catch {
            throw error
        }
    }
    
    func fetchBuses() async throws -> [BusEntity] {
        guard let googleFeedUrl = googleFeedTrasportServiceURL else {
            throw BusesUseCasesError.gftsServiceNotFound
        }
        do {
            let feedBuses = try await repository.fetchBuses(url: googleFeedUrl)
            let buses = feedBuses.filter{ $0.hasVehicle }.compactMap{ entity -> BusEntity? in
                if let route = routesUseCases.routes.first(where: { $0.lineId == entity.vehicle.trip.routeID }) {
                    let bus = BusEntity(
                        id: entity.vehicle.vehicle.id,
                        position: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(entity.vehicle.position.latitude),
                            longitude: CLLocationDegrees(entity.vehicle.position.longitude)
                        ),
                        routeID: entity.vehicle.trip.routeID,
                        lineName: route.lineName
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

struct BusesUseCasesKey: DependencyKey {
    static var liveValue: BusesUseCasesProtocol = BusesUseCases()
}


extension DependencyValues {
    var busesUseCases: BusesUseCasesProtocol {
        get { self[BusesUseCasesKey.self] }
        set { self[BusesUseCasesKey.self] = newValue }
    }
}
