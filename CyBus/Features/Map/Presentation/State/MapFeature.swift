//
//  MapFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import ComposableArchitecture
import MapboxMaps
import UIKit

@Reducer
struct MapFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        // Features
        var userLocation = LocationFeature.State()
        var mapCamera = CameraFeature.State()
        
        //State vars
        var error: String?
//        var buses: [BusEntity] = []
//        var selection: (bus: BusEntity, route: BusRouteEntity)?
        
    }
    
    enum Action {
        case userLocation(LocationFeature.Action)
        case mapCamera(CameraFeature.Action)
        
        case onMapInit
        case onMapLoaded(error: String?)
        
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    @Dependency(\.mapUseCases) var mapUseCases
    @Dependency(\.busesUseCases) var busesUseCases
    @Dependency(\.routesUseCases) var routesUseCases
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userLocation, action: \.userLocation) {
            LocationFeature()
        }
        Scope(state: \.mapCamera, action: \.mapCamera) {
            CameraFeature()
        }
        Reduce { state, action in
            switch action {
            case let .onMapLoaded(error):
                // TODO: UI errors
                if let mapError = error {
                    state.error = mapError
                }
                return .none
            case .onMapInit:
                return .run { @MainActor send in
                    var initializationError: String?
                    do {
                        try busesUseCases.fetchServiceUrl()
                        try await routesUseCases.fetchRoutes()
                    } catch {
                        // TODO: UI errors
                        initializationError = "Failed to load Map \(error)"
                    }
                    send(.onMapLoaded(error: initializationError))
                }
            case .userLocation(.onLocationUpdate):
                if let location = state.userLocation.location {
                    return .send(.mapCamera(.onViewportChange(location)))
                } else {
                    state.alert = AlertState {
                        TextState("Location is not available")
                    } actions: {
                        ButtonState(role: .none, action: .openSettingsTapped, label: { TextState("Open settings") })
                        ButtonState(role: .cancel, label: { TextState("Cancel") })
                    }
                    return .none
                }
            case .alert(.presented(.openSettingsTapped)):
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
                return .none
            case .alert(_), .userLocation(_), .mapCamera(_):
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
}
