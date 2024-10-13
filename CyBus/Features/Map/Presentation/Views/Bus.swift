//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct Bus: View {
    var lineName: String
    
    var body: some View {
        VStack(spacing: 00) {
            Text(lineName)
                .font(.caption)
                .padding(3)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 3)
            Image("bus")
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}
