//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI
struct Bus: View {
    var lineName: String
    var lineColor: Color
    
    var body: some View {
        ZStack {
            MarkerIcon()
                .frame(width: 37, height: 51)
            
            VStack(spacing: 00) {
                Text(lineName)
                    .frame(width: 35)
                    .foregroundColor(.white)
                    .font(.caption)
                    .background(lineColor)
                    .cornerRadius(16)
                    .padding(.bottom, 11)
                
                Image(systemName: "bus.fill")
                    .frame(width: 19.41, height: 19.5)
                    .padding(.bottom, 40)
            }
        }
        .shadow(radius: 3, x: 1, y: 1)
        .foregroundStyle(lineColor)
    }
    
}



