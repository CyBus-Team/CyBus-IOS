//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import MapboxSearch

@Reducer
struct AddressSearchResultFeature {
    
    @ObservableState
    struct State : Equatable {
        var detailedSuggestion: DetailedSuggestionEntity?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onGetDirections
        case onClose
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onGetDirections:
                return .none
                
            case .binding(_), .onClose:
                return .none
                
            }
        }
    }
    
}
