//
//  HomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    let mapStore: StoreOf<MapFeature> = Store(initialState: MapFeature.State()) {
        MapFeature()
    }
    
    let busesStore: StoreOf<BusesFeature> = Store(initialState: BusesFeature.State()) {
        BusesFeature()
    }
    
    let routesStore: StoreOf<RoutesFeature> = Store(initialState: RoutesFeature.State()) {
        RoutesFeature()
    }
    
    var body: some View {
        TabView {
            MapView(
                mapStore: mapStore,
                cameraStore: mapStore.scope(state: \.mapCamera, action: \.mapCamera),
                locationStore: mapStore.scope(state: \.userLocation, action: \.userLocation),
                busesStore: busesStore,
                routesStore: routesStore
            )
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            Text("In progress...")
                .tabItem {
                    Label("Search", systemImage: "point.bottomleft.forward.to.point.topright.scurvepath")
                }
                .tag(2)
            Text("In progress...")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(3)
        }
    }
    
}
