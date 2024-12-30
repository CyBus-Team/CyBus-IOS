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
    
    let searchStore: StoreOf<SearchFeatures> = Store(initialState: SearchFeatures.State()) {
        SearchFeatures()
    }
    
    var body: some View {
        TabView {
            VStack {
                MapView(
                    mapStore: mapStore,
                    cameraStore: mapStore.scope(state: \.mapCamera, action: \.mapCamera),
                    locationStore: mapStore.scope(state: \.userLocation, action: \.userLocation),
                    busesStore: busesStore
                )
                SearchView(store: searchStore)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(1)
            Text("In progress...")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
    }
    
}
