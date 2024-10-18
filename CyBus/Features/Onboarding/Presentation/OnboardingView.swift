//
//  OnboardingView.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    let store: StoreOf<OnboardingFeature> = Store(initialState: OnboardingFeature.State()) {
        OnboardingFeature()
    }
    
    var body: some View {
        NavigationStack {
            switch (store.page) {
                case .welcome: OnboardingWelcomeView(store: store)
                case .geolocation: OnboardingGeolocationView(store: store)
                case .login: OnboardingLoginView(store: store)
            }
        }
    }
}
