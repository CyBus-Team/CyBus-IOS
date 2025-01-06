//
//  LocationButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct LocationButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "location.fill")
                .font(.system(size: 24))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        
    }
}
