//
//  AddressSearchRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import CoreLocation

enum AddressSearchRepositoryError: Error {
    case fetchFailed
}

protocol AddressSearchRepositoryProtocol {
    func fetch(query: String, userLocation: CLLocationCoordinate2D) async throws -> [SuggestionDTO]
}
