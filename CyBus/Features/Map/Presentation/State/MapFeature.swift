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
        
    }
    
    enum Action {
        case userLocation(LocationFeature.Action)
        case mapCamera(CameraFeature.Action)
        
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userLocation, action: \.userLocation) {
            LocationFeature()
        }
        Scope(state: \.mapCamera, action: \.mapCamera) {
            CameraFeature()
        }
        Reduce { state, action in
            switch action {
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
