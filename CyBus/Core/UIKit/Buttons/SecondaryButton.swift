//
//  SecondaryButton.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI

struct SecondaryButton : View {
    @Environment(\.theme) var theme
    
    var label: String
    var action: () -> Void
    var font: Font?
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .font(font ?? theme.typography.title)
                .foregroundColor(theme.colors.primary)
                .padding(.vertical, 8)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(theme.colors.primary, lineWidth: 2)
                )
                .hoverEffect()
        }
    }
}

