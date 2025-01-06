//
//  FavouritesButton.swift
//  CyBus
//
//  Created by Vadim Popov on 05/01/2025.
//

import SwiftUI

struct FavouritesButton: View {
    @Environment(\.theme) var theme
    
    var action: @MainActor () -> Void
    var isActive: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isActive ? "bookmark.fill" : "bookmark")
                .background(theme.colors.textFieldBackground)
                .cornerRadius(12)
        }
    }
}
