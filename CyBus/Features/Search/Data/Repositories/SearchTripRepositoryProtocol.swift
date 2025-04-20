//
//  SearchTripRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import CoreLocation

protocol SearchTripRepositoryProtocol {
    func fetchTrips(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, date: Date) async throws -> TripResponseDTO 
}
