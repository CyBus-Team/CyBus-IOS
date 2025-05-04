//
//  LocationFeature.swift
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
    struct State : Equatable {
        var location: CLLocationCoordinate2D?
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs.location, rhs.location) {
            case let (.some(lhsLoc), .some(rhsLoc)):
                return lhsLoc.latitude == rhsLoc.latitude && lhsLoc.longitude == rhsLoc.longitude
            case (nil, nil):
                return true
            default:
                return false
            }
        }
    }
    
    enum Action {
        case getCurrentLocation
        case onLocationResponse(CLLocationCoordinate2D?)
    }
    
    @Injected(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .onLocationResponse(currentLocation):
                state.location = currentLocation
                return .none
                
            case .getCurrentLocation:
                return .run { @MainActor send in
                    let currentLocation = try? await locationUseCases.getCurrentLocation()
                    send(.onLocationResponse(currentLocation))
                }
                
            }
        }
    }
}
