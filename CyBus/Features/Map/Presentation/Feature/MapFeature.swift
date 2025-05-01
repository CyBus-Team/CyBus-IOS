//
//  MapFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import ComposableArchitecture
import Factory
import _MapKit_SwiftUI
import SwiftUI

@Reducer
struct MapFeature {
    
    let defaultCameraDistance = 1500.0
    
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action.Alert>?
        
        // Features
        var userLocation = LocationFeature.State()
        var search = SearchFeatures.State()
        
        //State vars
        var error: String?
        var isLoading: Bool = true
        var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case userLocation(LocationFeature.Action)
        case search(SearchFeatures.Action)
        case setUp
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userLocation, action: \.userLocation) {
            LocationFeature()
        }
        Scope(state: \.search, action: \.search) {
            SearchFeatures()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setUp:
                do {
                    state.isLoading = false
                    return .send(.userLocation(.getCurrentLocation))
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
                if let location = suggestion?.location {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        state.cameraPosition = .camera(.init(centerCoordinate: location, distance: state.cameraPosition.camera?.distance ?? defaultCameraDistance))
                    }
                }
                return .none
            case .search(.searchAddressResult(.onGetTripsResponse(_))):
                withAnimation(.easeInOut(duration: 1.0)) {
                    state.cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
                }
                return .none
            case .alert(_), .userLocation(_), .search(_), .binding(_):
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
}
