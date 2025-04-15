//
//  NodeStop.swift
//  CyBus
//
//  Created by Vadim Popov on 04/02/2025.
//

import SwiftUI

struct NodeStop: View {
    @Environment(\.theme) var theme
    
    let line: String
    let scale: Double
    
    var body: some View {
        VStack(spacing: 10) {
            Text(line)
                .font(theme.typography.title)
                .frame(width: 30)
                .foregroundColor(theme.colors.foreground)
                .background(theme.colors.primary)
                .cornerRadius(16)
            ZStack {
                Circle()
                    .fill(theme.colors.background)
                    .frame(width: 32, height: 32)
                Image(systemName: "figure.wave.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(theme.colors.primary)
            }
        }
        .scaleEffect(scale)
    }
}


#Preview {
    NodeStop(line: "21", scale: 1)
}
