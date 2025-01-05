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
    @Bindable var addressResultStore: StoreOf<AddressSearchResultFeature>
    
    var body: some View {
        SearchCollapsedView(store: store)
            .sheet(isPresented: $store.addressResultOpened) {
                AddressSearchResultView(store: addressResultStore)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.2)])
            }
            .sheet(isPresented: $store.addressSearchOpened) {
                AddressSearchView(store: addressSearchStore)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
            }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchFeatures.State()) {
        SearchFeatures()
    }, addressSearchStore: Store(initialState: AddressSearchFeature.State()) {
        AddressSearchFeature()
    }, addressResultStore: Store(initialState: AddressSearchResultFeature.State()) {
        AddressSearchResultFeature()
    })
}
