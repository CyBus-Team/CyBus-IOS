//
//  OnboardingLoginView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingSignInView: View {
    
    @Bindable var store: StoreOf<OnboardingSignInFeature>
    
    var body: some View {
        VStack {
            SecondaryButton(label: "Not Now") {
                store.send(.notNowTapped)
            }
            PrimaryButton(label: "Sign up") {
                store.send(.signUpTapped)
            }
            PrimaryButton(label: "Log in") {
                store.send(.loginTapped)
            }
        }
        
    }
}
