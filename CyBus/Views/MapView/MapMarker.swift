//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct CustomMapMarker: View {
    var bus: Bus
    
    var body: some View {
        VStack {
            Text(bus.route?.lineName ?? "")
                .font(.caption)
                .padding(5)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 3)
            
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}
