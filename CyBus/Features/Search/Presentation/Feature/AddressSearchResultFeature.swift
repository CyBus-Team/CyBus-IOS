//
//  AddressAutocompleteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct AddressSearchResultFeature {
    
    @ObservableState
    struct State : Equatable {
        var suggestedTrips: [SearchTripEntity] = [] {
            didSet {
                hasSuggestedTrips = !suggestedTrips.isEmpty
            }
        }
        var hasSuggestedTrips: Bool = false
        var selectedTrip: SearchTripEntity?
        var isLoading: Bool = true
        var isTripsLoading: Bool = false
        var hasSuggestion: Bool = false
        var suggestion: SuggestionEntity? {
            didSet {
                if let suggestion {
                    hasSuggestion = true
                }
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setup(SuggestionEntity?)
        case onGetTrips
        case onGetTripsResponse([SearchTripEntity])
        case onChooseTrip(SearchTripEntity?)
        case onClose
        case onCloseTrips
        case onReset
    }
    
    @Injected(\.searchTripUseCases) var useCases
    @Injected(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .setup(suggestion):
                state.suggestion = suggestion
                state.isLoading = false
                return .none
                
            case .onGetTrips:
                state.isTripsLoading = true
                state.suggestedTrips = []
                guard let to = state.suggestion?.location else {
                    return .none
                }
                return .run { @MainActor send in
                    if let from = try await locationUseCases.getCurrentLocation() {
                        let trips = try await useCases.fetchTrips(from: from, to: to)
                        return send(.onGetTripsResponse(trips))
                    }
                    return send(.onGetTripsResponse([]))
                }
                
            case let .onGetTripsResponse(trips):
                state.isTripsLoading = false
                state.suggestedTrips = trips
                return .run { send in
                    return await send(.onClose)
                }
            case let .onChooseTrip(trip):
                state.selectedTrip = trip
                return .none
            case .onReset:
                state.suggestedTrips = []
                state.selectedTrip = nil
                return .none
                
            case .binding(_), .onClose, .onCloseTrips:
                return .none
            }
        }
    }
    
}
