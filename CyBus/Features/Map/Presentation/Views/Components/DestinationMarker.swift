//
//  DestinationMarker.swift
//  CyBus
//
//  Created by Vadim Popov on 06/01/2025.
//

import SwiftUI

struct DestinationMarker: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.red)
            .background(.white)
    }
    
}

#Preview {
    DestinationMarker()
}
