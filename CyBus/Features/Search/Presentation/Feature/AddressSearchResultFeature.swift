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
        var nodes: [TripNodeEntity] = []
        var isLoading: Bool = true
        var isNodesLoading: Bool = false
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
        case onGetDirectionsResponse([TripNodeEntity])
        case onClose
        case onReset
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
                state.isNodesLoading = true
                state.nodes = []
                let to = state.detailedSuggestion!.location
                return .run { @MainActor send in
                    let from = try await locationUseCases.getCurrentLocation()
                    let stops = try await useCases.getStops(from: from!, to: to)
                    let nodes = try await useCases.getNodes(from: stops)
                    return send(.onGetDirectionsResponse(nodes))
                }
                
            case let .onGetDirectionsResponse(nodes):
                state.isNodesLoading = false
                state.nodes = nodes
                return .run { send in
                    return await send(.onClose)
                }
            
            case .onReset:
                state.nodes = []
                return .none
                
            case .binding(_), .onClose:
                return .none
                
            }
        }
    }
    
}
