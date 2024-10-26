//
//  WelcomeView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture



struct OnboardingWelcomeView: View {
    @Environment(\.theme) var theme
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        
        let backgroundGradient = LinearGradient(
            colors: [theme.colors.foreground, theme.colors.background],
            startPoint: .top, endPoint: .bottom)
        
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
  
            VStack {
                Text("Welcome to \nCyprusGo!")
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .aspectRatio(contentMode: .fill)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Track buses in real time, plan \nroutes and add your favorite \nstops to your favorites.")
                    .padding(.bottom, 25)
                    .font(theme.typography.title)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.primary)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("onboard_welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                PrimaryButton(label: "Get Start") {
                    store.send(.getStartTapped)
                } .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 37)
            .padding(.vertical, 34)
        }
        
    }
    
}

#Preview {
    OnboardingWelcomeView(store: Store(initialState: OnboardingFeature.State()) {
        OnboardingFeature()
    })
}



