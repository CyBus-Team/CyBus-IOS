//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import MapboxSearch

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
    
    @Dependency(\.addressAutocompleteUseCases) var useCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setup:
                return .run { send in
                    try useCases.setup()
                }
                
            case .onSubmit:
                state.detailedSuggestion = nil
                state.isLoading = true
                let query = state.query
                return .run { send in
                    do {
                        if let result = try await useCases.fetch(query: query) {
                            await send(.onGetSuggestions(result))
                        } else {
                            await send(.onGetSuggestions(nil))
                        }
                    } catch {
                        await send(.onGetSuggestions(nil))
                    }
                }
                
            case let .onGetSuggestions(suggestions):
                state.suggestions = suggestions ?? []
                state.isLoading = false
                return .none
                
                
            case let .onSelect(suggestion):
                return .run { send in
                    do {
                        if let result = try await useCases.select(suggestion: suggestion) {
                            await send(.onGetDetailedSuggestion(result))
                        } else {
                            await send(.onGetDetailedSuggestion(nil))
                        }
                    } catch {
                        await send(.onGetDetailedSuggestion(nil))
                    }
                }
                
            case let .onGetDetailedSuggestion(detailedSuggestion):
                state.detailedSuggestion = detailedSuggestion
                return .none
            
            case .onReset:
                state.detailedSuggestion = nil
                return .none
                
            case .binding(_):
                return .none
                
            }
        }
    }
    
}
