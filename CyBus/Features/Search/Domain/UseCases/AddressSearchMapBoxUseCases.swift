//
//  AddressSearchMapBoxUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import MapboxSearch
import Foundation
import ComposableArchitecture

class AddressSearchMapBoxUseCases : AddressSearchUseCasesProtocol {
    
    private let repository: AddressSearchRepositoryProtocol
    private let locationUseCases: LocationUseCasesProtocol
    
    init(repository: AddressSearchRepositoryProtocol = AddressSearchMapBoxRepository(), locationUseCases: LocationUseCasesProtocol = LocationUseCases()) {
        self.repository = repository
        self.locationUseCases = locationUseCases
    }
    
    func setup() throws {
        do {
            try repository.setup()
        } catch {
            throw error
        }
    }
    
    func fetch(query: String) async throws -> [AddressEntity]? {
        do {
            guard let userLocation = try await locationUseCases.getCurrentLocation() else {
                throw AddressSearchUseCasesError.fetchFailed
            }
            return try await repository.fetch(query: query, userLocation: userLocation).compactMap { AddressEntity.from(dto: $0) }
        } catch {
            throw AddressSearchUseCasesError.fetchFailed
        }
        
    }
    
    func select(suggestion: AddressEntity) throws {
        print("TODO")
    }
    
}

struct AddressAutocompleteUseCasesKey: DependencyKey {
    static var liveValue: AddressSearchUseCasesProtocol = AddressSearchMapBoxUseCases()
}

extension DependencyValues {
    var addressAutocompleteUseCases: AddressSearchUseCasesProtocol {
        get { self[AddressAutocompleteUseCasesKey.self] }
        set { self[AddressAutocompleteUseCasesKey.self] = newValue }
    }
}

