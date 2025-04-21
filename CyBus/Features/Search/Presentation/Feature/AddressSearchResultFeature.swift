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
        var detailedSuggestion: DetailedSuggestionEntity? {
            didSet {
                hasSuggestion = detailedSuggestion != nil
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setup(DetailedSuggestionEntity?)
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
                state.detailedSuggestion = suggestion
                state.isLoading = false
                return .none
                
            case .onGetTrips:
                state.isTripsLoading = true
                state.suggestedTrips = []
                let to = state.detailedSuggestion!.location
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
