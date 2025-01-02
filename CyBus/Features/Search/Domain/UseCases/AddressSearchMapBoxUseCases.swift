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
    
    init(repository: AddressSearchRepositoryProtocol = AddressSearchMapBoxRepository()) {
        self.repository = repository
    }
    
    func setup() throws {
        do {
            try repository.setup()
        } catch {
            throw error
        }
    }
    
    func fetch(query: String, completion: @escaping (Result<[AddressEntity], Error>) -> Void) {
        repository.fetch(query: query) { suggestions in
            if let result = suggestions {
                let entities = result.compactMap { AddressEntity.from(dto: $0) }
                completion(.success(entities))
            } else {
                completion(.failure(AddressSearchUseCasesError.fetchFailed))
            }
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

