//
//  SplashView.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI

struct SplashView: View {
    
    @Environment(\.theme) var theme
    
    @AppStorage("skipOnboarding") private var skipOnboarding: Bool?
    
    var body: some View {
        NavigationStack {
            if let skipOnboarding = skipOnboarding {
                if skipOnboarding {
                    NavigationLink(destination: MapView()) {
                        EmptyView()
                    }
                } else {
                    NavigationLink(destination: OnboardingView()) {
                        EmptyView()
                    }
                }
            } else {
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
                )
            }
        }
    }
}
