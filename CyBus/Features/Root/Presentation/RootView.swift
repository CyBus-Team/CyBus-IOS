//
//  RootView.swift
//  CyBus
//
//  Created by Vadim Popov on 16/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {

    @AppStorage(ThemeKey.identifier) private var themeMode: String = ThemeKey.defaultValue.mode.rawValue
    
    let rootStore: StoreOf<RootFeature> = Store(initialState: RootFeature.State()) {
        RootFeature()
    }
    
    private var isDark: Bool {
        get { themeMode == ThemeMode.dark.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            switch (rootStore.page) {
                case .logo: LogoView()
                case .onboarding: OnboardingView()
                case .home: MapView()
            }
        }.environment(\.theme, isDark ? .dark : .light).onAppear {
            rootStore.send(.showLogo)
        }
    }
}
