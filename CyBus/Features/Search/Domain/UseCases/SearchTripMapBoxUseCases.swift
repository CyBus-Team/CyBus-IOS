//
//  SearchTripMapBoxUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Factory

class SearchTripMapBoxUseCases: SearchTripUseCasesProtocol {
    
    @Injected(\.searchTripRepository) var repository: SearchTripRepositoryProtocol
    
    init(
        repository: SearchTripRepositoryProtocol = Container.shared.searchTripRepository()
    ) {
        self.repository = repository
    }
    
}
