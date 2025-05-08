//
//  AddressSearchFeatureTests.swift
//  CyBus
//
//  Created by Vadim Popov on 08/05/2025.
//

import Testing
import ComposableArchitecture
import Factory

@testable import CyBus

@MainActor
struct AddressSearchFeaturesTests {
    
    @Test("Resets all state variables")
    func resetState() async {
        // GIVEN
        let store = TestStore(initialState: AddressSearchFeature.State(
            query: "query",
            suggestions: MockSuccessAddressSearchUseCase.items,
            selection: MockSuccessAddressSearchUseCase.items.first
        )) {
            AddressSearchFeature()
        }
        store.exhaustivity = .off
        
        // WHEN
        await store.send(.onReset)
        
        // THEN
        store.assert { state in
            state.query = ""
            state.suggestions = []
            state.selection = nil
            state.isLoading = false
        }
    }
    
    @Test("Suggestion updates selection")
    func updateSelection() async {
        // GIVEN
        let suggestion = MockSuccessAddressSearchUseCase.items.first!
        let query = "query"
        let store = TestStore(initialState: AddressSearchFeature.State(
            query: query,
            suggestions: MockSuccessAddressSearchUseCase.items,
            selection: nil
        )) {
            AddressSearchFeature()
        }
        store.exhaustivity = .off
        
        //WHEN
        await store.send(.onSelect(suggestion))

        //THEN
        store.assert { state in
            state.isLoading = store.state.isLoading
            state.query = store.state.query
            state.suggestions = store.state.suggestions
            state.selection = suggestion
        }
    }
    
    @Test("Must update state suggestions")
    func getSuggestions() async {
        // GIVEN
        let suggestions = MockSuccessAddressSearchUseCase.items
        let store = TestStore(initialState: AddressSearchFeature.State(
            isLoading: true
        )) {
            AddressSearchFeature()
        }
        store.exhaustivity = .off
        
        //WHEN
        await store.send(.onGetSuggestions(suggestions))

        //THEN
        store.assert { state in
            state.isLoading = false
            state.suggestions = suggestions
        }
    }
    
    @Test("Must update state suggestions from useCase")
    func submitSuggestions() async {
        // GIVEN
        Container.shared.addressSearchUseCases.register { MockSuccessAddressSearchUseCase() }
        let store = TestStore(initialState: AddressSearchFeature.State()) {
            AddressSearchFeature()
        }
        store.exhaustivity = .off
        
        // WHEN
        await store.send(.onSubmit)
        
        // THEN
        await store.receive(\.onGetSuggestions) {
            $0.suggestions = MockSuccessAddressSearchUseCase.items
        }
    
        store.assert { state in
            state.selection = nil
            state.isLoading = false
            state.suggestions = MockSuccessAddressSearchUseCase.items
        }
    }
    
    @Test("Must clear state suggestions on error")
    func submitFetchingError() async {
        // GIVEN
        Container.shared.addressSearchUseCases.register { MockErrorAddressSearchUseCase() }
        let store = TestStore(initialState: AddressSearchFeature.State()) {
            AddressSearchFeature()
        }
        store.exhaustivity = .off
        
        // WHEN
        await store.send(.onSubmit)
        
        // THEN
        await store.receive(\.onGetSuggestions) {
            $0.suggestions = []
        }
        store.assert { state in
            state.selection = nil
            state.isLoading = false
            state.suggestions = []
        }
    }
}
