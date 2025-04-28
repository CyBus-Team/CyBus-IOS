//
//  AddressSearchMapBoxUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import Foundation
import Factory

class AddressSearchUseCases : AddressSearchUseCasesProtocol {
    
    @Injected(\.addressSearchRepository) var repository: AddressSearchRepositoryProtocol
    @Injected(\.locationUseCases) var locationUseCases: LocationUseCasesProtocol
    
    func fetch(query: String) async throws -> [SuggestionEntity]? {
        do {
            guard let userLocation = try await locationUseCases.getCurrentLocation() else {
                throw AddressSearchUseCasesError.fetchFailed
            }
            return try await repository.fetch(query: query, userLocation: userLocation).compactMap { SuggestionEntity.from(dto: $0) }
        } catch {
            throw AddressSearchUseCasesError.fetchFailed
        }
    }
    
}
