//
//  ZoomButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct ZoomButton: View {
    var action: () -> Void
    var zoomIn: Bool

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: zoomIn ? "plus.magnifyingglass" : "minus.magnifyingglass")
                .font(.system(size: 24))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        
    }
}
