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
        var isLoading: Bool = true
        var isDirectionsLoading: Bool = false
        var hasSuggestion: Bool = false
        var detailedSuggestion: DetailedSuggestionEntity? {
            didSet {
                hasSuggestion = detailedSuggestion != nil
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setup(DetailedSuggestionEntity?)
        case onGetDirections
        case onGetDirectionsResponse
        case onClose
    }
    
    @Dependency(\.addressPathUseCases) var useCases
    @Dependency(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .setup(suggestion):
                state.detailedSuggestion = suggestion
                state.isLoading = false
                return .none
                
            case .onGetDirections:
                state.isDirectionsLoading = true
                let to = state.detailedSuggestion!.location
                debugPrint("to \(to)")
                return .run { @MainActor send in
                    let from = try await locationUseCases.getCurrentLocation()
                    debugPrint("from \(from)")
                    try await useCases.findPath(from: from!, to: to)
                }
                
            case .onGetDirectionsResponse:
                state.isDirectionsLoading = false
                return .none
                
            case .binding(_), .onClose:
                return .none
                
            }
        }
    }
    
}
