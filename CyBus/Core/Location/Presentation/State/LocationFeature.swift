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
        //Limassol by default
        var location: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
        var error: String?
    }
    
    enum Action {
        case goToCurrentLocation
        case listenLocationChanges
        case getInitialLocation
        case initialLocationResponse(CLLocationCoordinate2D?)
        case onLocationUpdate(CLLocationCoordinate2D?)
    }
    
    @Dependency(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .listenLocationChanges:
                return .none
            case let .onLocationUpdate(location), let .initialLocationResponse(location):
                state.location = location
                return .none
            case .getInitialLocation:
                return .run { @MainActor send in
                    let location = try? await locationUseCases.getCurrentLocation()
                    send(.initialLocationResponse(location))
                }
            case .goToCurrentLocation:
                return .run { @MainActor send in
                    let location = try? await locationUseCases.getCurrentLocation()
                    send(.onLocationUpdate(location))
                }
            }
        }
    }
}
