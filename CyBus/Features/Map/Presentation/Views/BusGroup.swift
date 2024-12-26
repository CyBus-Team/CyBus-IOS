//
//  BusGruup.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct BusGroup: View {
    let activeBus: BusEntity?
    let buses: [BusEntity]
    let scale: Double
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack {
            VStack {
                ForEach(buses, id: \.self) {
                    Text($0.lineName)
                        .frame(width: 36)
                        .foregroundColor(.white)
                        .font(.caption)
                        .background(theme.colors.primary)
                        .cornerRadius(16)
                        .opacity(activeBus == nil ? 1 : activeBus == $0 ? 1 : 0.5)
                }
            }
            
            ZStack {
                MarkerIcon()
                    .frame(width: 36, height: 50)
                Image(systemName: "bus.fill")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
        }
        .shadow(radius: 3, x: 1, y: 1)
        .foregroundStyle(theme.colors.primary)
        .opacity(activeBus == nil ? 1 : buses.contains(activeBus!) ? 1 : 0.5)
        .scaleEffect(scale)
    }
    
}



