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
        case onCloseAutoComplete
        case onOpenFavourites
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onOpenAutoComplete:
                state.autoCompleteOpened = true
                return .none
            case .onCloseAutoComplete:
                state.autoCompleteOpened = false
                return .none
            case .onOpenFavourites:
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
