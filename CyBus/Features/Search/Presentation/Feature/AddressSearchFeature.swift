//
//  AddressSearchFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import Factory
import MapboxSearch

@Reducer
struct AddressSearchFeature {

    @ObservableState
    struct State: Equatable {
        var error: String?
        var isLoading: Bool = false
        var query: String = ""
        var suggestions: [SuggestionEntity] = []
        var selection: SuggestionEntity?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onSubmit
        case onReset
        case onGetSuggestions([SuggestionEntity]?)
        case onSelect(SuggestionEntity)
    }

    @Injected(\.addressSearchUseCases) var useCases

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onSubmit:
                state.selection = nil
                state.isLoading = true
                let query = state.query
                return .run { @MainActor send in
                    do {
                        let suggestions = try await useCases.fetch(query: query)
                        send(.onGetSuggestions(suggestions))
                    } catch {
                        send(.onGetSuggestions(nil))
                    }
                }

            case let .onGetSuggestions(suggestions):
                state.suggestions = suggestions ?? []
                state.isLoading = false
                return .none
                
            case let .onSelect(suggestion):
                state.selection = suggestion
                return .none

            case .onReset:
                state.query = ""
                state.suggestions = []
                state.selection = nil
                return .none

            case .binding(_):
                return .none

            }
        }
    }

}
