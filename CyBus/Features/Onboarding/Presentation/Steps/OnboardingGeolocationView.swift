//
//  GeolocationView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingGeolocationView: View {
    
    @Bindable var store: StoreOf<OnboardingRequestGeolocationFeature>
    
    var body: some View {
        VStack {
            SecondaryButton(label: "Not now") {
                store.send(.notNowTapped)
            }
            PrimaryButton(label: "Next") {
                store.send(.nextTapped)
            }
            PrimaryButton(label: "Allow location") {
                store.send(.locationTapped)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
