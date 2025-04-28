//
//  SearchDI.swift
//  CyBus
//
//  Created by Vadim Popov on 07/04/2025.
//

import Factory
import Foundation

extension Container {
    var searchTripRepository: Factory<SearchTripRepositoryProtocol> {
        self { SearchTripRepository() }
    }
    var searchTripUseCases: Factory<SearchTripUseCasesProtocol> {
        self { SearchTripUseCases() }
    }
    var addressSearchUseCases: Factory<AddressSearchUseCasesProtocol> {
        self { AddressSearchUseCases()}
            .singleton
    }
    var addressSearchRepository: Factory<AddressSearchRepositoryProtocol> {
        self { AddressSearchRepository()}
            .singleton
    }
}
