//
//  AddressSearchRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import CoreLocation

enum AddressSearchRepositoryError: Error {
    case initializationFailed
    case fetchFailed
}

protocol AddressSearchRepositoryProtocol {
    func setup() throws
    func fetch(query: String, userLocation: CLLocationCoordinate2D) async throws -> [SuggestionDTO]
    func select(suggestion: SuggestionEntity) async throws -> DetailedSuggestionDTO
}
