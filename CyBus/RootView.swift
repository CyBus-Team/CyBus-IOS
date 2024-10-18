//
//  RootView.swift
//  CyBus
//
//  Created by Vadim Popov on 16/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @AppStorage(OnboardingFeature.onboardingKey) private var skipOnboarding: Bool = false
    @AppStorage(ThemeKey.identifier) private var themeMode: String = ThemeKey.defaultValue.mode.rawValue
    
    private var isDark: Bool {
        get { themeMode == ThemeMode.dark.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            if !skipOnboarding {
                OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
                    OnboardingFeature()
                })
            } else {
                MapView()
            }
        }.environment(\.theme, isDark ? .dark : .light)
    }
}
