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
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack {
                        
                let height = UIScreen.main.bounds.height;
                let width = UIScreen.main.bounds.width;
        
                Text("Welcome to \nCyprusGo!")
                    .padding(.leading, width*0.0909)
                    .padding(.bottom, height*0.0209)
                    .padding(.top, UIScreen.main.bounds.height*0.0262)
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: width, alignment: .leading)
        
                Text("Track buses in real time, plan \nroutes and add your favorite \nstops to your favorites.")
                    .padding(.leading, width*0.0909)
                    .padding(.bottom, height*0.0262)
                    .font(theme.typography.title)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.primary)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: width, alignment: .leading)
                  
                Image("onboard_welcome")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width*0.9791, height: height*0.4874)
                        .padding(.bottom, height*0.0418)
               
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        PrimaryButton(label: "Get Start") {
                            store.send(.getStartTapped)
                        }  .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .padding(.leading, height*0.0628)
                    }
                }
         
            }

        }
        
    }
        
}


