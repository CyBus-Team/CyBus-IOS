//
//  AddressSearchResultView.swift
//  CyBus
//
//  Created by Vadim Popov on 03/01/2025.
//

import SwiftUI
import ComposableArchitecture
import MapboxSearch

struct AddressSearchResultView : View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<AddressSearchResultFeature>
    
    var body: some View {
        if store.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading) {
                
                Spacer()
                
                // MARK: Place info
                Text(store.detailedSuggestion?.name ?? "-")
                    .font(theme.typography.title)
                
                Text(store.detailedSuggestion?.description ?? "-")
                    .font(theme.typography.regular)
                
                Spacer()
                
                // MARK: Actions
                HStack() {
                    // MARK: Directions
                    if store.isDirectionsLoading {
                        ProgressView()
                    } else {
                        PrimaryButton(
                            label: "Directions",
                            action: {
                                store.send(.onGetDirections)
                            },
                            font: theme.typography.regular
                        )
                    }
                    // MARK: Favourites
                    // TODO: Implement favourites
                    SecondaryButton(
                        label: "Add to favourites",
                        action: {
                            
                        },
                        font: theme.typography.regular
                    )
                    
                    Spacer()
                }
            }
            .padding()
            .background(theme.colors.background)
        }
        
    }
}

#Preview {
    AddressSearchResultView(store: Store(initialState: AddressSearchResultFeature.State(
        isLoading: false,
        isDirectionsLoading: true,
        detailedSuggestion: DetailedSuggestionEntity.mock
    )) {
        AddressSearchResultFeature()
    })
}
