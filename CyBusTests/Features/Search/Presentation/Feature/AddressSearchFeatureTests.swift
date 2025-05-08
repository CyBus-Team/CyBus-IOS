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
            suggestions: SuccessAddressSearchUseCase.items,
            selection: SuccessAddressSearchUseCase.items.first,
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
        }
    }
    
}
