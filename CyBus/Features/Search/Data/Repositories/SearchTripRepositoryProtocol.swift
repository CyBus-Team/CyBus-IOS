//
//  SearchTripRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

enum TripSearchRepositoryError: Error {
    case fileNotFound
}

protocol SearchTripRepositoryProtocol {
    func getTrips() async throws -> [SearchTripDTO]
    func getStops() async throws -> [SearchStopDTO]
    func getCities() throws -> [CityDTO]
}
