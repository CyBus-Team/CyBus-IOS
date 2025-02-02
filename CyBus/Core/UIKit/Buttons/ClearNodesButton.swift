//
//  ClearNodesButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct ClearNodesButton: View {
    @Environment(\.theme) var theme
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text("Finish")
            Image(systemName: "mappin.circle.fill")
        }
        .padding()
        .background(theme.colors.primary)
        .foregroundColor(theme.colors.background)
        .clipShape(.capsule)
        .shadow(radius: 10)
    }
}

#Preview {
    ClearNodesButton(action: {
        print("Clear")
    })
}

