//
//  OnboardingLoginView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingLoginView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        HStack {
            SecondaryButton(label: "Now Now") {
                store.send(.notNowSignInTapped)
            }
            PrimaryButton(label: "Sign in") {
                store.send(.signInTapped)
            }
        }
        
    }
}
