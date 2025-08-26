//
//  RootView.swift
//  CyBus
//
//  Created by Vadim Popov on 16/10/2024.
//

import SwiftUI
import ComposableArchitecture
import FactoryKit

struct RootView: View {
    
    @AppStorage(ThemeKey.identifier) private var themeMode: String = ThemeKey.defaultValue.mode.rawValue
    
    //MARK: DI
    @Injected(\.advertisingFeature) var advertisingFeature: StoreOf<AdvertisingFeature>
    let store: StoreOf<RootFeature> = Store(initialState: RootFeature.State()) {
        RootFeature()
    }
    
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
        }
        .task(priority: .high) {
            advertisingFeature.send(.requestUMP)
            advertisingFeature.send(.requestATT)
        }
        
    }
}
