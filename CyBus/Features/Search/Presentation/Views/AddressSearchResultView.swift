//
//  AddressSearchResultView.swift
//  CyBus
//
//  Created by Vadim Popov on 03/01/2025.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

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
                Text(store.suggestion?.label ?? "-")
                    .font(theme.typography.title)
                
                //                Text(store.detailedSuggestion?.description ?? "-")
                //                    .font(theme.typography.regular)
                
                Spacer()
                
                // MARK: Actions
                HStack() {
                    // MARK: Directions
                    PrimaryButton(
                        label: String(localized: "Get directions"),
                        action: {
                            store.send(.onGetTrips)
                        },
                        isLoading: store.isTripsLoading,
                        font: theme.typography.regular
                    )
                    if (store.hasSuggestedTrips) {
                        // MARK: Finish route
                        SecondaryButton(
                            label: String(localized: "Finish"),
                            action: {
                                store.send(.onReset)
                                store.send(.onClose)
                            },
                            font: theme.typography.regular
                        )
                    }
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
        isTripsLoading: true,
        suggestion: SuggestionEntity(
            id: 1,
            label: "My mall",
            location: CLLocationCoordinate2D(latitude: 1, longitude: 1)
        )
    )) {
        AddressSearchResultFeature()
    })
}
