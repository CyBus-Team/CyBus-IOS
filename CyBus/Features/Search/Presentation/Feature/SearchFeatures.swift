//
//  SearchFeatures.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture

@Reducer
struct SearchFeatures {
    
    @ObservableState
    struct State: Equatable {
        // State vars
        var autoCompleteOpened: Bool = false
        var autoCompleteResultsOpened: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onOpenAutoComplete
        case onOpenSearchResults
        case onOpenFavourites
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onOpenAutoComplete:
                state.autoCompleteOpened = true
                state.autoCompleteResultsOpened = false
                return .none
            case .onOpenSearchResults:
                state.autoCompleteOpened = false
                state.autoCompleteResultsOpened = true
                return .none
            case .onOpenFavourites:
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
