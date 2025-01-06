//
//  LocationButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct LocationButton: View {
    @Environment(\.theme) var theme
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "location.fill")
                .font(.system(size: 24))
                .foregroundColor(theme.colors.primary)
        }
        .frame(width: 70, height: 70)
        .background(
            Circle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        
    }
}

#Preview {
    LocationButton(
        action: { debugPrint("get location") }
    )
}
