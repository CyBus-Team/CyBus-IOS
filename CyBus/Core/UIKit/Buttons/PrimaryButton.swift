//
//  PrimaryButton.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUI

struct PrimaryButton : View {
    @Environment(\.theme) var theme
    
    let label: String
    let action: () -> Void
    var isLoading: Bool = false
    var font: Font?
    
    var body: some View {
        Button {
            isLoading ? nil : action()
        } label: {
            if self.isLoading {
                ProgressView().tint(theme.colors.background)
            } else {
                Text(label)
                    .font(font ?? theme.typography.title)
            }
        }
        .padding(.vertical, 8)
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

#Preview {
    VStack {
        PrimaryButton(
            label: "Primary button", action: { debugPrint("On tap") },
            isLoading: false, font: .body
        )
        PrimaryButton(
            label: "Primary button", action: { debugPrint("On tap") },
            isLoading: true, font: .body
        )
    }
}
