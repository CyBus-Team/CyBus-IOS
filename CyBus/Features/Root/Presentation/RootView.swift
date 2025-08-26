//
//  RootView.swift
//  CyBus
//
//  Created by Vadim Popov on 16/10/2024.
//

import SwiftUI
import FactoryKit
import ComposableArchitecture

struct RootView: View {
    
    @AppStorage(ThemeKey.identifier) private var themeMode: String = ThemeKey.defaultValue.mode.rawValue
    
    let store: StoreOf<RootFeature> = Store(initialState: RootFeature.State()) {
        RootFeature()
    }
    
    @Injected(\.rateUsFeature) var storeRateUs: StoreOf<RateUsFeatures>
    
    private var isDark: Bool {
        get { themeMode == ThemeMode.dark.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            switch store.page {
            case .home: HomeView()
            case .onboarding: OnboardingView()
            case .logo: LogoView()
            }
        }
        .environment(\.theme, isDark ? .dark : .light)
        .task(priority: .background) {
            store.send(.initApp)
            storeRateUs.send(.initAppState) 
        }
        
    }
}
