//
//  GeolocationView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingGeolocationView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        HStack {
            SecondaryButton(label: "Now Now") {
                store.send(.notNowGeolocationTapped)
            }
            PrimaryButton(label: "Next") {
                store.send(.nextTapped)
            }
        }
        
    }
}
