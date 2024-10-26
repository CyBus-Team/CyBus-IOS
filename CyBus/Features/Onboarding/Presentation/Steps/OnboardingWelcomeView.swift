//
//  WelcomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingWelcomeView: View {
    
    @Bindable var onboardingStore: StoreOf<OnboardingFeatures>
    
    var body: some View {
        PrimaryButton(label: "Get Start") {
            onboardingStore.send(.getStartTapped)
        }
    }
}
