//
//  HomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import SwiftUI
import ComposableArchitecture
import Factory

struct HomeView: View {
    
    @State private var isSearchPresented = true
    
    //MARK: DI
    @Injected(\.mapFeature) var mapStore: StoreOf<MapFeature>
    @Injected(\.busesFeature) var busesStore: StoreOf<BusesFeature>
    
    var body: some View {
        VStack {
            MapView(
                mapStore: mapStore,
                cameraStore: mapStore.scope(state: \.mapCamera, action: \.mapCamera),
                locationStore: mapStore.scope(state: \.userLocation, action: \.userLocation),
                busesStore: busesStore,
                searchStore: mapStore.scope(state: \.search, action: \.search)
            )
            SearchView(
                store: mapStore.scope(state: \.search, action: \.search),
                addressSearchStore: mapStore.scope(state: \.search, action: \.search).scope(state: \.searchAddress, action: \.searchAddress),
                addressResultStore: mapStore.scope(state: \.search, action: \.search).scope(state: \.searchAddressResult, action: \.searchAddressResult)
            )
        }
    }
    
}
