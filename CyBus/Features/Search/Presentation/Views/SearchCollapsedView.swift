//
//  SearchCollapsedView.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct SearchCollapsedView : View {
    @Environment(\.theme) var theme
    @Bindable var store: StoreOf<SearchFeatures>
    
    var body: some View {
        // MARK: Actions
        HStack {
            // MARK: Open search button
            Button {
                store.send(.onOpenAddressSearch)
            } label: {
                Text("Search here")
                    .font(theme.typography.regular)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.colors.textFieldBackground)
                    .cornerRadius(12)
            }
            
            Spacer()
            
            // MARK: Favourites
            FavouritesButton(
                action: { store.send(.onOpenFavourites) },
                isActive: true
            )
            .padding(12)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 14)
        .padding(.top, 6)
        .background(.white)
        .foregroundColor(theme.colors.linkTitle)
        .cornerRadius(12)
    }
    
}
