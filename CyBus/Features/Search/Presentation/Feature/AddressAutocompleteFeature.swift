//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import MapboxSearch

@Reducer
struct AddressAutocompleteFeature {
    
    @ObservableState
    struct State : Equatable {
        var isLoading: Bool = false
        var query: String = ""
        var results: [AddressEntity] = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onSubmit
        case onGetResults([AddressEntity])
        case onChoose(AddressEntity)
    }
    
    @Dependency(\.addressAutocompleteUseCases) var useCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .onGetResults(results):
                state.results = results
                state.isLoading = false
                return .none
                
            case .onSubmit:
                state.isLoading = true
                let query = state.query
                return .run { @MainActor send in
                    useCases.fetch(query: query) { (result: Result<[AddressEntity], Error>) in
                        switch result {
                        case .success(let suggestions):
                            send(.onGetResults(suggestions))
                        case .failure(let error):
                            send(.onGetResults([]))
                        }
                    }
                }
            case let .onChoose(address):
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
    
}
