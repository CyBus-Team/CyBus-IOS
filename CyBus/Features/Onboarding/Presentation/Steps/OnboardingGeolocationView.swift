//
//  GeolocationView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingGeolocationView: View {
    @Environment(\.theme) var theme
    @Bindable var store: StoreOf<OnboardingRequestGeolocationFeature>
    
    var body: some View {
        
        let backgroundGradient = LinearGradient(
            colors: [theme.colors.foreground, theme.colors.background],
            startPoint: .top, endPoint: .bottom)
        
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            VStack {
                Image("onboarding_map")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 37)
                
                Text("Allow access to geolocation")
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("To show you your current location and the nearest buses, we need access to your geolocation.")
                    .font(theme.typography.title)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack {
                    PrimaryButton(label: "Allow") {
                        store.send(.locationTapped)
                    }
                    Spacer()
                    SecondaryButton(label: "Not now") {
                        store.send(.notNowTapped)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 37)
            .padding(.vertical, 34)
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    OnboardingGeolocationView(store: Store(initialState: OnboardingRequestGeolocationFeature.State()) {
        OnboardingRequestGeolocationFeature()
    })
}
