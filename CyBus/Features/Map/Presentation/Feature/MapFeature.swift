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
        var search = SearchFeatures.State()
        
        //State vars
        var error: String?
        var isLoading: Bool = true
        
    }
    
    enum Action {
        case userLocation(LocationFeature.Action)
        case mapCamera(CameraFeature.Action)
        case search(SearchFeatures.Action)
        
        case setUp
        
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    @Dependency(\.mapUseCases) var mapUseCases
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userLocation, action: \.userLocation) {
            LocationFeature()
        }
        Scope(state: \.mapCamera, action: \.mapCamera) {
            CameraFeature()
        }
        Scope(state: \.search, action: \.search) {
            SearchFeatures()
        }
        Reduce { state, action in
            switch action {
            case .setUp:
                do {
                    state.isLoading = true
                    try mapUseCases.setup()
                    state.isLoading = false
                    return .send(.userLocation(.getCurrentLocation))
                } catch {
                    // TODO: UI errors
                    state.isLoading = false
                    state.error = "Failed to init Map \(error)"
                }
                return .none
                
            case .userLocation(.onLocationResponse):
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
            case let .search(.searchAddressResult(.setup(suggestion))):
                return .run { send in
                    await send(.mapCamera(.onViewportChange(suggestion!.location)))
                }
            case .alert(_), .userLocation(_), .mapCamera(_), .search(_):
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
}
