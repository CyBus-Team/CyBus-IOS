//
//  SearchFeatures.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import SwiftUI
import FactoryKit

@Reducer
struct SearchFeatures {
    
    @ObservableState
    struct State: Equatable {
        // State vars
        var addressSearchOpened: Bool = false
        var addressResultOpened: Bool = false
        var tripSelectorOpened: Bool = false
        var rateUsOpened: Bool = false
        // Features
        var searchAddressResult = AddressSearchResultFeature.State()
        var searchAddress = AddressSearchFeature.State()
        var rateUs = RateUsFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onOpenAddressSearch
        case onOpenAddressSearchResults
        case onReset
        case onOpenFavourites
        case searchAddressResult(AddressSearchResultFeature.Action)
        case searchAddress(AddressSearchFeature.Action)
        case rateUs(RateUsFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.searchAddress, action: \.searchAddress) {
            AddressSearchFeature()
        }
        Scope(state: \.searchAddressResult, action: \.searchAddressResult) {
            AddressSearchResultFeature()
        }
        Scope(state: \.searchAddressResult, action: \.searchAddressResult) {
            AddressSearchResultFeature()
        }
        Scope(state: \.rateUs, action: \.rateUs) {
            RateUsFeature()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            // Search
            case .onOpenAddressSearch:
                state.addressSearchOpened = true
                state.addressResultOpened = false
                state.tripSelectorOpened = false
                state.rateUsOpened = false
                return .none
            case .onOpenAddressSearchResults:
                state.addressSearchOpened = false
                state.tripSelectorOpened = false
                state.addressResultOpened = true
                state.rateUsOpened = false
                return .none
            case .onOpenFavourites:
                return .none
            case .binding(_):
                return .none
            // Search suggestions
            case let .searchAddress(.onSelect(suggestion)):
                state.addressSearchOpened = false
                state.tripSelectorOpened = false
                state.addressResultOpened = true
                state.rateUsOpened = false
                return .run { send in
                    await send(.searchAddressResult(.setup(suggestion)))
                }
            case .searchAddress(_):
                return .none
            // Search results
            case .searchAddressResult(.onCloseTrips):
                withAnimation(.easeOut(duration: 0.5)) {
                    state.addressSearchOpened = false
                    state.addressResultOpened = false
                    state.tripSelectorOpened = false
                    state.rateUsOpened = false
                }
                return .run { send in
                    await send(.rateUs(.initFeature))
                }
            case .searchAddressResult(.onClose), .searchAddressResult(.binding(_)):
                state.addressResultOpened = false
                state.rateUsOpened = false
                return .none
            case .searchAddressResult(.onGetTripsResponse(_)):
                state.addressSearchOpened = false
                state.addressResultOpened = false
                state.rateUsOpened = false
                state.tripSelectorOpened = true
                return .none
            case .searchAddressResult(_):
                return .none
            // Rate Us
            case let .rateUs(.initResponse(needToShow)):
                state.rateUsOpened = needToShow
                return .none
            case .rateUs(.submitReviewResponse),
                    .rateUs(.onDismiss):
                state.rateUsOpened = false
                return .none
            case .rateUs(_):
                return .none
            // Map actions
            case .onReset:
                return .run { send in
                    await send(.searchAddressResult(.onReset))
                    await send(.searchAddress(.onReset))
                }
            }
        }
    }
}
