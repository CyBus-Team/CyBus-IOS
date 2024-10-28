//
//  OnboardingView.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    let onboardingStore: StoreOf<OnboardingFeatures> = Store(initialState: OnboardingFeatures.State()) {
        OnboardingFeatures()
    }
    
    var body: some View {
        NavigationStack() {
            switch (onboardingStore.page) {
            case .welcome: OnboardingWelcomeView(
                store: onboardingStore.scope(state: \.welcome, action: \.welcome)
            )
            case .geolocation: OnboardingGeolocationView(
                store: onboardingStore.scope(state: \.geolocation, action: \.geolocation)
            )
            case .login: OnboardingLoginView(onboardingStore: onboardingStore)
            }
        }
    }
}

