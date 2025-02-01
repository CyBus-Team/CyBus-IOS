//
//  HomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    @State private var isSearchPresented = true
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ]
        )
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray3
        
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image
        
        UITabBar.appearance().standardAppearance = appearance
    }
    
    let mapStore: StoreOf<MapFeature> = Store(initialState: MapFeature.State()) {
        MapFeature()
    }
    
    let busesStore: StoreOf<BusesFeature> = Store(initialState: BusesFeature.State()) {
        BusesFeature()
    }
    
    var body: some View {
        TabView {
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
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(1)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
    }
    
}
