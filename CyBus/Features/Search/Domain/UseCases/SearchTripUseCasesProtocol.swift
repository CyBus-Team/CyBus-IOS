//
//  SearchTripUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

enum SearchTripUseCasesError: Error {
    case apiNotAvailable
}

protocol SearchTripUseCasesProtocol {
    func fetchTrips(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [SearchTripEntity]
}
