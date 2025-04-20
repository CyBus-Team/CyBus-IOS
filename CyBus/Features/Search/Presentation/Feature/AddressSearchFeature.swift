//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import MapboxSearch
import Factory

@Reducer
struct AddressSearchFeature {
    
    @ObservableState
    struct State : Equatable {
        var error: String?
        var isLoading: Bool = false
        var query: String = ""
        var suggestions: [SuggestionEntity] = []
        var detailedSuggestion: DetailedSuggestionEntity?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setup
        case onSubmit
        case onReset
        case onGetSuggestions([SuggestionEntity]?)
        case onSelect(SuggestionEntity)
        case onGetDetailedSuggestion(DetailedSuggestionEntity?)
    }
    
    @Injected(\.addressSearchUseCases) var useCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setup:
                return .run { @MainActor send in
                    try useCases.setup()
                }
                
            case .onSubmit:
                state.detailedSuggestion = nil
                state.isLoading = true
                let query = state.query
                return  .run { @MainActor send in
                    do {
                        if let result = try await useCases.fetch(query: query) {
                            send(.onGetSuggestions(result))
                        } else {
                            send(.onGetSuggestions(nil))
                        }
                    } catch {
                        send(.onGetSuggestions(nil))
                    }
                }
                
            case let .onGetSuggestions(suggestions):
                state.suggestions = suggestions ?? []
                state.isLoading = false
                return .none
                
                
            case let .onSelect(suggestion):
                return .run { @MainActor send in
                    do {
                        if let result = try await useCases.select(suggestion: suggestion) {
                            send(.onGetDetailedSuggestion(result))
                        } else {
                            send(.onGetDetailedSuggestion(nil))
                        }
                    } catch {
                        send(.onGetDetailedSuggestion(nil))
                    }
                }
                
            case let .onGetDetailedSuggestion(detailedSuggestion):
                state.detailedSuggestion = detailedSuggestion
                return .none
                
            case .onReset:
                state.query = ""
                state.suggestions = []
                state.detailedSuggestion = nil
                return .none
                
            case .binding(_):
                return .none
                
            }
        }
    }
    
}
