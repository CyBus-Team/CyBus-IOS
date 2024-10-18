//
//  WelcomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingWelcomeView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        PrimaryButton(label: "Get Start") {
            store.send(.getStartTapped)
        }
    }
}
