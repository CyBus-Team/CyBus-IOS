//
//  SearchMocks.swift
//  CyBus
//
//  Created by Vadim Popov on 08/05/2025.
//

import CoreLocation

struct MockErrorAddressSearchUseCase: AddressSearchUseCasesProtocol {
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        throw AddressSearchUseCasesError.fetchFailed
    }
}

struct MockSuccessAddressSearchUseCase: AddressSearchUseCasesProtocol {
    
    static let items : [SuggestionEntity] = [
        SuggestionEntity(id: 1, label: "First", location: MockSuccessAddressSearchUseCase.location),
        SuggestionEntity(id: 2, label: "Second", location: MockSuccessAddressSearchUseCase.location),
        SuggestionEntity(id: 3, label: "Third", location: MockSuccessAddressSearchUseCase.location),
    ]
        
    static let location = CLLocationCoordinate2D(latitude: 1, longitude: 1)
    
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        MockSuccessAddressSearchUseCase.items
    }
}
