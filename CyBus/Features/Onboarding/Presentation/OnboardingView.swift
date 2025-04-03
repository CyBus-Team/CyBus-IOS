//
//  OnboardingView.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI
import ComposableArchitecture
import Factory

struct OnboardingView: View {
    
    @Injected(\Container.onboardingFeature) var onboardingStore: StoreOf<OnboardingFeatures>
    
    var body: some View {
        NavigationStack() {
            switch (onboardingStore.page) {
            case .welcome: OnboardingWelcomeView(
                store: onboardingStore.scope(state: \.welcome, action: \.welcome)
            )
            case .geolocation: OnboardingGeolocationView(
                store: onboardingStore.scope(state: \.geolocation, action: \.geolocation)
            )
            case .login: OnboardingSignInView(
                store: onboardingStore.scope(state: \.signIn, action: \.signIn)
            )
            case .home:
                HomeView()
            }
        }
    }
}

