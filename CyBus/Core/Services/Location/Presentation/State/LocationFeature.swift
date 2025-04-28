//
//  LocationViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 04/10/2024.
//

import CoreLocation
import ComposableArchitecture
import Factory

@Reducer
struct LocationFeature {
    
    @ObservableState
    struct State {
        var location: CLLocationCoordinate2D?
        var error: String?
    }
    
    enum Action {
        case getCurrentLocation
        case onLocationResponse(CLLocationCoordinate2D?)
    }
    
    @Injected(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .onLocationResponse(location):
                state.location = location
                return .none
                
            case .getCurrentLocation:
                return .run { @MainActor send in
                    let location = try? await locationUseCases.getCurrentLocation()
                    send(.onLocationResponse(location))
                }
                
            }
        }
    }
}
