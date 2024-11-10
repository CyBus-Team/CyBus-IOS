//
//  HomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import SwiftUI

struct HomeView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)
            Text("In progress...")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
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
