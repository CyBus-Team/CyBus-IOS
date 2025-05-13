//
//  ClearRouteButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct ClearRouteButton: View {
    @Environment(\.theme) var theme
    
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .clipShape(Circle())
            Text(label)
            Image(systemName: "bus.fill")
        }
        .padding()
        .background(theme.colors.primary)
        .foregroundColor(theme.colors.background)
        .clipShape(.capsule)
        .shadow(radius: 10)
    }
}

#Preview {
    ClearRouteButton(
        label: "10",
        action: {
            print("Clear")
        }
    )
}

