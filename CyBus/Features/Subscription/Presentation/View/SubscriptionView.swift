//
//  SubscriptionView.swift
//  CyBus
//
//  Created by Vadim Popov on 03/09/2025.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

// MARK: - View
struct SubscriptionView: View {
    @Environment(\.theme) var theme
    
    var body: some View {        
        ZStack {
            LinearGradient(
                colors: [theme.colors.foreground, theme.colors.background],
                startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                Text("Upgrade to Plus")
                    .font(theme.typography.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image("subscription_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding(.vertical, 16)
                
                Spacer()
                
                VStack {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Bullet(text: "No ads", color: theme.colors.primary, emoji: "🚫")
                        Bullet(text: "Unique app icon", color: theme.colors.primary, emoji: "⚡")
                        Bullet(text: "Works with Apple Family Sharing", color: theme.colors.primary, emoji: "🧑‍🧑‍🧒")
                        Bullet(text: "Support dev team", color: theme.colors.primary, emoji: "💙")
                    }
                    
                    Spacer()
                    
                    VStack {
                        PrimaryButton(
                            label: String(localized: "Price/month"), expanded: true) {
                                
                            }
                        PrimaryButton(
                            label: String(localized: "Price/year 45% off"), expanded: true) {
                                
                            }
                        SecondaryButton(
                            label: String(localized: "Not now"), expanded: true) {
                                
                            }
                        HStack(spacing: 4) {
                            Text("Already have a subscription?")
                                .foregroundStyle(.secondary)
                            Button {
                                
                            } label: {
                                Text("Restore")
                                    .underline()
                                    .foregroundStyle(theme.colors.primary)
                            }
                        }
                        .font(.callout)
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 24)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaPadding()
    }
    
}

#Preview {
    SubscriptionView()
}
