//
//  AddressSearchUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//


enum AddressSearchUseCasesError: Error {
    case initializationFailed
    case fetchFailed
    case selectionFailed
}

protocol AddressSearchUseCasesProtocol {
    func setup() throws
    func fetch(query: String) async throws -> [SuggestionEntity]?
    func select(suggestion: SuggestionEntity) async throws -> DetailedSuggestionEntity?
}
