//
//  SearchMocks.swift
//  CyBus
//
//  Created by Vadim Popov on 08/05/2025.
//

import CoreLocation

struct ErrorAddressSearchUseCase: AddressSearchUseCasesProtocol {
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        throw AddressSearchUseCasesError.fetchFailed
    }
}

struct EmptyAddressSearchUseCase: AddressSearchUseCasesProtocol {
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        []
    }
}

struct SuccessAddressSearchUseCase: AddressSearchUseCasesProtocol {
    
    static let items = [
        SuggestionEntity(id: 1, label: "First", location: SuccessAddressSearchUseCase.location),
        SuggestionEntity(id: 2, label: "Second", location: SuccessAddressSearchUseCase.location),
        SuggestionEntity(id: 3, label: "Third", location: SuccessAddressSearchUseCase.location),
    ]
        
    static let location = CLLocationCoordinate2D(latitude: 1, longitude: 1)
    
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        SuccessAddressSearchUseCase.items
    }
}
