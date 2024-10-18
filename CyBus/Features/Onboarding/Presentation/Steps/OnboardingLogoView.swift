//
//  OnboardingLogoView.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingLogoView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("splash_logo").resizable().frame(width: 160, height: 142)
                Text("CyprusGo").font(theme.typography.largeTitleLogo).foregroundStyle(theme.colors.primary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [theme.colors.foreground, theme.colors.background]), startPoint: .top, endPoint: .bottom
            )
        ).onAppear {
            store.send(.skipLogo)
        }
    }
}
