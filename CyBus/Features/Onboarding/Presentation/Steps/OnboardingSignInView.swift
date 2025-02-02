//
//  OnboardingLoginView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingSignInView: View {
    @Environment(\.theme) var theme
    @Bindable var store: StoreOf<OnboardingSignInFeature>
    
    var body: some View {
        
        let backgroundGradient = LinearGradient(
            colors: [theme.colors.foreground, theme.colors.background],
            startPoint: .top, endPoint: .bottom)
        
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Log in for more convenient use")
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 23)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("You can sign in to save your favorite routes and receive personalized notifications. ")
                    .font(theme.typography.title)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("onboarding_signup")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 27)
                
                Spacer()
                
                HStack {
                    PrimaryButton(label: String(localized: "Sign up")) {
                        store.send(.signUpTapped)
                    }
                    Spacer()
                    SecondaryButton(label: String(localized: "Not Now")) {
                        store.send(.notNowTapped)
                    }
                }
                .padding(.bottom, 27)
                
                HStack {
                    Text("Already have an account?")
                        .font(theme.typography.regular)
                        .foregroundStyle(theme.colors.linkTitle)
                    
                    Text("Log In")
                        .font(theme.typography.regular)
                        .foregroundStyle(theme.colors.primary)
                        .underline()
                }
                .onTapGesture {
                    store.send(.loginTapped)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 37)
            .padding(.top, 34)
            .padding(.bottom, 0)
        }
        
    }
}

#Preview {
    OnboardingSignInView(store: Store(initialState: OnboardingSignInFeature.State()) {
        OnboardingSignInFeature()
    })
}
