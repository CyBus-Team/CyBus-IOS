//
//  AddressSearchResultView.swift
//  CyBus
//
//  Created by Vadim Popov on 03/01/2025.
//

import SwiftUI

struct AddressSearchResultView {
    @Environment(\.theme) var theme
    
    var name: String
    
    var body: some View {
        VStack {
            // MARK: Place info
            HStack {
                Text(name)
                    .font(theme.typography.regular)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            
            // MARK: Actions
            HStack {
                // MARK: Directions
                // TODO: Implement directions
                Button {
                    
                } label: {
                    Text("Get directions")
                        .font(theme.typography.regular)
                }
                
                // MARK: Favourites
                // TODO: Implement favourites
                FavouritesButton(
                    action: { },
                    isActive: true
                )
            }
        }
    }
}
