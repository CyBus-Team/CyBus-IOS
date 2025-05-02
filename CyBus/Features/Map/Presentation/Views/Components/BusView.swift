//  BusView.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

enum BusViewState {
    case selected
    case unselected
    case none
}

struct BusView: View {
    @Environment(\.theme) var theme
    
    let bus: BusEntity
    let state: BusViewState
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(bus.lineName)
                .frame(width: 36)
                .foregroundColor(.white)
                .font(.caption)
                .background(theme.colors.primary)
                .cornerRadius(16)
                .opacity(state == .none ? 1 : state == .selected ? 1 : 0.5)
            
            ZStack {
                BusMarker()
                    .frame(width: 36, height: 50)
                Image(systemName: "bus.fill")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
        }
        .shadow(radius: 3, x: 1, y: 1)
        .foregroundStyle(theme.colors.primary)
        .opacity(state == .none ? 1 : state == .selected ? 1 : 0.5)
        .onTapGesture {
           action()
        }
    }
    
}



