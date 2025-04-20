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
        self { SearchTripRepositoryLocal() }
    }
    var searchTripUseCases: Factory<SearchTripUseCasesProtocol> {
        self { SearchTripMapBoxUseCases() }
    }
    var addressSearchUseCases: Factory<AddressSearchUseCasesProtocol> {
        self { AddressSearchMapBoxUseCases()}
            .singleton
    }
    var addressSearchRepository: Factory<AddressSearchRepositoryProtocol> {
        self { AddressSearchMapBoxRepository()}
            .singleton
    }
}
