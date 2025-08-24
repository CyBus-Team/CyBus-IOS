//
//  StopCircle.swift
//  CyBus
//
//  Created by Vadim Popov on 04/09/2024.
//

import SwiftUI

struct StopCircle : View {
    var color: Color
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
                .frame(width: 15, height: 15)
        }
        .shadow(radius: 3, x: 1, y: 1)
    }
}

#Preview {
    StopCircle(color: .blue)
}
