//
//  LocationViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 04/10/2024.
//

import CoreLocation
import ComposableArchitecture

@Reducer
struct LocationFeature {
    
    @ObservableState
    struct State: Equatable {
        var location: CLLocationCoordinate2D?
        var error: String?
    }
    
    enum Action {
        case goToCurrentLocation
        case listenLocationChanges
        case onLocationUpdate(CLLocationCoordinate2D?)
    }
    
    @Dependency(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .listenLocationChanges:
                return .none
            case let .onLocationUpdate(location):
                state.location = location
                return .none
            case .goToCurrentLocation:
                return .run { @MainActor send in
                    let location = try? await locationUseCases.getCurrentLocation()
                    send(.onLocationUpdate(location))
                }
            }
        }
    }
}
