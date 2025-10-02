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
    
    @Bindable var store: StoreOf<SubscriptionFeature>
    
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
                        Bullet(text: "Works with Apple Family Sharing", color: theme.colors.primary, emoji: "🧑‍🧑‍🧒")
                        Bullet(text: "Support dev team", color: theme.colors.primary, emoji: "💙")
                    }
                    
                    Spacer()
                    
                    VStack {
                        if !store.products.isEmpty {
                            ForEach(store.products, id: \.id) { product in
                                ZStack(alignment: .topTrailing) {
                                    PrimaryButton(
                                        label: "\(product.name) \(product.price)",
                                        expanded: true
                                    ) {
                                        store.send(.subscribe(product))
                                    }
                                    if product.period == .yearly {
                                        Text("Save 45%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(4)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                            .offset(x: -8, y: -10)
                                    }
                                }
                            }
                        }
                    }
                    SecondaryButton(
                        label: String(localized: "Not now"), expanded: true) {
                            store.send(.fetchProducts)
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
        .task(priority: .high) {
            store.send(.fetchProducts)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaPadding()
    }
    
}

#Preview {
    SubscriptionView(store: Store(initialState: SubscriptionFeature.State()) {
        SubscriptionFeature()
    })
}
