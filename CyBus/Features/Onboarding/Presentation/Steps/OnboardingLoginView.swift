//
//  OnboardingLoginView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingLoginView: View {
    
    @Bindable var onboardingStore: StoreOf<OnboardingFeatures>
    
    var body: some View {
        HStack {
            SecondaryButton(label: "Now Now") {
                onboardingStore.send(.notNowSignInTapped)
            }
            PrimaryButton(label: "Sign in") {
                onboardingStore.send(.signInTapped)
            }
        }
        
    }
}
