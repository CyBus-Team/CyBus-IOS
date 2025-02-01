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
                .frame(width: 11, height: 11)
        }
        .shadow(radius: 3, x: 1, y: 1)
    }
}

#Preview {
    StopCircle(color: .blue)
}
