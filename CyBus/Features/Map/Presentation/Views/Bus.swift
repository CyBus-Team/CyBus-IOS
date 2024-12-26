//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

enum BusState {
    case active
    case inactive
    case none
}

struct Bus: View {
    var lines: [String]
    var state: BusState
    var scale: Double
    var activeBusIndex: Int?
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack {
            VStack {
                ForEach(lines.indices, id: \.self) { index in
                    Text(lines[index])
                        .frame(width: 36)
                        .foregroundColor(.white)
                        .font(.caption)
                        .background(theme.colors.primary)
                        .cornerRadius(16)
                        .opacity(state == .none ? 1 : state == .active && activeBusIndex == index ? 1 : 0.5)
                }
            }
            
            ZStack {
                MarkerIcon()
                    .frame(width: 36, height: 50)
                
                Image(systemName: "bus.fill")
                    .frame(width: 20, height: 20)
                    .padding(.bottom, 15)
            }
        }
        .shadow(radius: 3, x: 1, y: 1)
        .foregroundStyle(theme.colors.primary)
        .opacity(state == .inactive ? 0.5 : 1)
        .scaleEffect(scale)
    }
    
}



