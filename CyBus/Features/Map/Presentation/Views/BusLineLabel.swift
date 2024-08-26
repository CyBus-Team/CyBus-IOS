//
//  MapMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 22/07/2024.
//

import SwiftUI

struct BusLineLabel: View {
    var lineName: String
    
    var body: some View {
        VStack {
            Text(lineName)
                .font(.caption)
                .padding(5)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 3)
            
            Image(systemName: "bus")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}
