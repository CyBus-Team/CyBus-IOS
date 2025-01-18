//
//  SearchTripUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

enum SearchTripUseCasesError: Error {
    case noRouteFound
    case noStartStopFound
    case noEndStopFound
}

protocol SearchTripUseCasesProtocol {
    func findTrip(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [TripNodeEntity]
}
