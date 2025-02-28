//
//  SearchTripUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

enum SearchTripUseCasesError: Error {
    case apiNotAvailable
    case noRouteFound
    case noStartStopFound
    case noEndStopFound
    case cityNotFound
}

protocol SearchTripUseCasesProtocol {
    func getStops(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [SearchStopEntity]
    func getNodes(
        for stops: [SearchStopEntity],
        from userLocation: CLLocationCoordinate2D,
        to destionation: CLLocationCoordinate2D
    ) async throws -> [TripNodeEntity]
}
