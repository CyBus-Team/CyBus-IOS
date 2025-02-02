//
//  ProfileAccount.swift
//  CyBus
//
//  Created by Artem on 18.1.25..
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    @Environment(\.theme) var theme
    let loginned = true
    let imageAvatar: String = "profile_cybus"
    
    // TOOO: image from Fairbase if exist

    var body: some View {
        
        ZStack {
            VStack {
                Image(imageAvatar)
                    .resizable()
                    .frame(width: 152, height: 152)
                    .padding(20)
                    .clipShape(Circle())
                    .onTapGesture {
                        // TODO: Edit image avatar
                    }
                Text("Cybus")
                    .font(theme.typography.title)
                    .foregroundStyle(.black)
                Text("@cybus")
                    .font(theme.typography.regular)
                    .foregroundStyle(.gray)
                if loginned == false {
                    HStack {
                        SecondaryButton(label: String(localized: "Sing up")) {
                            // TODO: Sing up navigation
                        }
                        PrimaryButton(label: String(localized: "Sing in")) {
                            // TODO: Sing in navigation
                        }
                    }
                    .padding(.all, 15)
                }
                else {
                    
                    PrimaryButton(label: String(localized: "Edit profile")) {
                        // TODO: Edit prifile page
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.all, 15)
                    
                }
                Divider()
                NavigationView {
                    VStack(alignment: .leading, spacing: 25) {
                        MenuItem(icon: "gear", title: String(localized: "Settings"))
                            .onTapGesture {
                                // TODO: Menu navigation
                            }
                        MenuItem(icon: "person.circle", title: String(localized: "Support"))
                            .onTapGesture {
                                // TODO: Menu navigation
                            }
                        MenuItem(icon: "square.and.arrow.up", title: String(localized: "Share"))
                            .onTapGesture {
                                // TODO: Menu navigation
                            }
                        MenuItem(icon: "questionmark.circle", title: String(localized:"About us"))
                            .onTapGesture {
                                // TODO: Menu navigation
                            }
                        if loginned == true {
                            MenuItem(icon: "arrowshape.turn.up.left", title: String(localized:"Log Out"))
                                .onTapGesture {
                                    // TODO: Menu navigation
                                }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 5)
            .padding(.vertical, 34)
        }
        
    }
    
}


struct MenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 20))
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

#Preview {
    ProfileView();
}
