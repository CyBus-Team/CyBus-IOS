//  BusView.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct BusView: View {
    @Environment(\.theme) var theme
    
    let bus: BusEntity
    let isActive: Bool?
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(bus.lineName)
                .frame(width: 36)
                .foregroundColor(.white)
                .font(.caption)
                .background(theme.colors.primary)
                .cornerRadius(16)
                .opacity(isActive == nil ? 1 : isActive == true ? 1 : 0.5)
            
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
        .opacity(isActive == nil ? 1 : isActive == true ? 1 : 0.5)
        .onTapGesture {
           action()
        }
    }
    
}



