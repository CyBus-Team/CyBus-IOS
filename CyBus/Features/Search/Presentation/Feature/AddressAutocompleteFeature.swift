//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import UIKit
import Foundation

@Reducer
struct AddressAutocompleteFeature {
    
    @ObservableState
    struct State : Equatable {
        var isLoading: Bool = false
        var query: String = ""
        var results: [AddressEntity]
    }
    
    enum Action {
        case onSubmit
        case onGetResults([AddressEntity])
        case onChoose(AddressEntity)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onGetResults(results):
                state.results = results
                state.isLoading = false
                return .none
                
            case .onSubmit:
                state.isLoading = true
                return .none
            
            case let .onChoose(address):
                return .none
                
            }
        }
    }
    
}
