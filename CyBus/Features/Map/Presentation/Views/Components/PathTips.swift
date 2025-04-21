//
//  PathTips.swift
//  CyBus
//
//  Created by Vadim Popov on 21/04/2025.
//

import SwiftUI

struct PathTips: View {
    
    let legs: [LegEntity]
    let hasSelectedLine: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if hasSelectedLine {
                    HStack(spacing: 8) {
                        Label("Selected line", systemImage: "bus.fill")
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 16, height: 4)
                    }
                }
                ForEach(legs) { leg in
                    HStack(spacing: 8) {
                        switch leg.mode {
                        case .foot:
                            Label("Foot path", systemImage: "figure.walk")
                        case .bus:
                            Label(leg.line ?? "bus", systemImage: "bus.fill")
                        default:
                            Label("Unknown", systemImage: "questionmark.square.dashed")
                        }
                        HStack(spacing: 2) {
                            if leg.mode == .bus {
                                Rectangle()
                                    .fill(leg.lineColor)
                                    .frame(width: 16, height: 4)
                            } else {
                                ForEach(0..<3) { _ in
                                    Circle()
                                        .fill(leg.lineColor)
                                        .frame(width: 4, height: 4)
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            .font(.caption)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
