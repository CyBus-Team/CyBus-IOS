//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct Bus: View {
    var lines: [String]
    var color: Color
    var isIncative: Bool = false
    var scale: Double
    
    var body: some View {
        VStack {
            VStack {
                ForEach(lines.indices, id: \.self) { index in
                    Text(lines[index])
                        .frame(width: 36)
                        .foregroundColor(.white)
                        .font(.caption)
                        .background(color)
                        .cornerRadius(16)
                }
            }
            
            ZStack {
                MarkerIcon()
                    .frame(width: 36, height: 50)
                
                Image(systemName: "bus.fill")
                    .frame(width: 20, height: 20)
                    .padding(.bottom, 10)
            }
        }
        .shadow(radius: 3, x: 1, y: 1)
        .foregroundStyle(color)
        .opacity(isIncative ? 0.5 : 1)
        .scaleEffect(scale)
    }
    
}



