//
//  PrimaryButton.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI

struct PrimaryButton : View {
    @Environment(\.theme) var theme
    
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(label)
                .font(theme.typography.title)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .foregroundStyle(theme.colors.background)
                .background(
                    RoundedRectangle(
                        cornerRadius: 32,
                        style: .continuous
                    ).fill(theme.colors.primary)
                )
               
        }
    }
}
