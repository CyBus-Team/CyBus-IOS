//
//  SearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 27/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct SearchView : View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<SearchFeatures>
    @Bindable var autocompleteStore: StoreOf<AddressAutocompleteFeature>
    
    var body: some View {
        SearchBarView(store: store)
            .sheet(isPresented: $store.autoCompleteOpened) {
                AddressSearchView(store: autocompleteStore).presentationDetents([.large])
            }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchFeatures.State()) {
        SearchFeatures()
    }, autocompleteStore: Store(initialState: AddressAutocompleteFeature.State()) {
        AddressAutocompleteFeature()
    })
}
