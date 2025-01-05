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
    @Bindable var addressSearchStore: StoreOf<AddressSearchFeature>
    
    var body: some View {
        SearchBarView(store: store)
            .sheet(isPresented: $store.autoCompleteOpened) {
                AddressSearchView(store: addressSearchStore).presentationDetents([.large])
            }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchFeatures.State()) {
        SearchFeatures()
    }, addressSearchStore: Store(initialState: AddressSearchFeature.State()) {
        AddressSearchFeature()
    })
}
