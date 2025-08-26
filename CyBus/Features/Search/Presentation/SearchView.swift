//
//  SearchView.swift
//  CyBus
//
//  Created by Vadim Popov on 27/12/2024.
//

import SwiftUI
import FactoryKit
import ComposableArchitecture

struct SearchView : View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<SearchFeatures>
    @Bindable var addressSearchStore: StoreOf<AddressSearchFeature>
    @Bindable var addressResultStore: StoreOf<AddressSearchResultFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var rateUsStore: StoreOf<RateUsFeatures>
    
    var body: some View {
        ZStack {
            if let selectedTrip = addressResultStore.selectedTrip, !store.tripSelectorOpened {
                
                ActiveTripView(
                    title: "Your location -> Destination",
                    arrivalTime: selectedTrip.endTime,
                    onFinish: {
                        store.send(.onReset)
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                SearchCollapsedView(store: store)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .sheet(isPresented: $store.rateUsOpened) {
                        RateUsMainView(store: rateUsStore)
                    }
                    .sheet(isPresented: $store.addressResultOpened) {
                        AddressSearchResultView(
                            store: addressResultStore,
                            busesStore: busesStore
                        )
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.fraction(0.2)])
                    }
                    .sheet(isPresented: $store.addressSearchOpened) {
                        AddressSearchView(
                            store: addressSearchStore,
                            busesStore: busesStore
                        )
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.large])
                    }
                    .sheet(isPresented: $store.tripSelectorOpened) {
                        TripSelectionView(store: addressResultStore)
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.large])
                    }
                    
            }
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: addressResultStore.selectedTrip
        )
    }
}

#Preview {
    SearchView(
        store: Store(initialState: SearchFeatures.State()) {
            SearchFeatures()
        },
        addressSearchStore: Store(initialState: AddressSearchFeature.State()) {
            AddressSearchFeature()
        },
        addressResultStore: Store(
            initialState: AddressSearchResultFeature.State()
        ) {
            AddressSearchResultFeature()
        },
        busesStore: Store(initialState: BusesFeature.State()) {
            BusesFeature()
        },
        rateUsStore: Store(initialState: RateUsFeatures.State()) {
            RateUsFeatures()
        },
    )
}
