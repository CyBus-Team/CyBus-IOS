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
    @State private var width = UIScreen.main.bounds.size.width / 1.3
    @State private var height = UIScreen.main.bounds.size.height / 1.5
    let store: StoreOf<OnboardingWelcomeFeature>
    
    var body: some View {
        
        let backgroundGradient = LinearGradient(
            colors: [theme.colors.foreground, theme.colors.background],
            startPoint: .top, endPoint: .bottom)
        
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
  
            VStack {
                Text("Welcome to CyprusGo!")
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Track buses in real time, plan routes and add your favorite stops to your favorites.")
                    .padding(.bottom, 25)
                    .font(theme.typography.title)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.primary)
                    .lineLimit(nil)
                  .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("onboard_welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                PrimaryButton(label: String(localized: "Get Start")) {
                    store.send(.getStartTapped)
                } .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 34)
            .padding(.vertical, 25)
        }
        
    }
    
}

#Preview {
    OnboardingWelcomeView(store: Store(initialState: OnboardingWelcomeFeature.State()) {
        OnboardingWelcomeFeature()
    })
}



