//
//  ZoomControlButton.swift
//  CyBus
//
//  Created by Vadim Popov on 06/01/2025.
//

import SwiftUI

struct ZoomControlView: View {
    @Environment(\.theme) var theme
    
    let onZoomIn: () -> Void
    let onZoomOut: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Button(action: onZoomIn) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.colors.primary)
            }
            .frame(width: 20, height: 20)
            .background(theme.colors.background)
            .clipShape(Circle())
            
            Divider()
                .frame(width: 40)
                .background(theme.colors.textFieldBackground)
            
            Button(action: onZoomOut) {
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.colors.primary)
            }
            .frame(width: 20, height: 20)
            .background(theme.colors.background)
            .clipShape(Circle())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.background)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    ZoomControlView(
        onZoomIn: { debugPrint("zoomIn") }, onZoomOut: { debugPrint("zoomOut") }
    )
}
