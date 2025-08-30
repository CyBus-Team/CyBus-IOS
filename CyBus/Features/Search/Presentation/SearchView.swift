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
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var advertisementsStore: StoreOf<AdvertisingFeature>
    
    var body: some View {
        ZStack {
            if let selectedTrip = addressResultStore.selectedTrip, !store.tripSelectorOpened {
                ActiveTripView(
                    title: "Your location -> Destination",
                    arrivalTime: selectedTrip.endTime
                ) {
                    store.send(.onReset)
                    advertisementsStore.send(.showAd)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                SearchCollapsedView(store: store)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .sheet(isPresented: $store.rateUsOpened) {
                        RateUsView(store: store.scope(
                            state: \.rateUs,
                            action: \.rateUs
                        ))
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.fraction(0.4)])
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
        .animation(.easeInOut(duration: 0.3), value: store.rateUsOpened)
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
        }
    )
}
