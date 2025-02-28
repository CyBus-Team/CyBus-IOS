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
    
    var body: some View {
        VStack(spacing: 2) {
            Text(line)
                .font(theme.typography.title)
                .foregroundColor(theme.colors.nodeColor)
            StopCircle(color: theme.colors.nodeColor)
        }
    }
    
}


#Preview {
    NodeStop(line: "21")
}
