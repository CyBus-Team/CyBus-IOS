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
        case setup
        case onSubmit
        case onGetResults([AddressEntity]?)
        case onChoose(AddressEntity)
    }
    
    @Dependency(\.addressAutocompleteUseCases) var useCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setup:
                return .run { send in
                    try useCases.setup()
                }
            case let .onGetResults(results):
                state.results = results ?? []
                state.isLoading = false
                return .none
                
            case .onSubmit:
                state.isLoading = true
                let query = state.query
                return .run { send in
                    do {
                        if let result = try await useCases.fetch(query: query) {
                            debugPrint("feature result \(result.count)")
                            await send(.onGetResults(result))
                        } else {
                            debugPrint("feature nil")
                            await send(.onGetResults(nil))
                        }
                    } catch {
                        debugPrint("feature nil 2")
                        await send(.onGetResults(nil))
                    }
                }
            case let .onChoose(suggestion):
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
    
}
