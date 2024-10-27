//
//  GeolocationStore.swift
//  CyBus
//
//  Created by Vadim Popov on 25/10/2024.
//

import ComposableArchitecture
import UIKit
import Foundation

@Reducer
struct RequestGeolocationFeature {
    
    @ObservableState
    struct State : Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var locationPermission = RecorderPermission.undetermined
        enum RecorderPermission {
            case allowed
            case denied
            case undetermined
        }
    }
    
    enum Action {
        case nextTapped
        case notNowTapped
        case locationTapped
        
        case permissionResponse(allowed: Bool, error: LocationUseCasesError?)
        
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    @Dependency(\.locationUseCases) var locationUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .nextTapped:
                return .none
                
            case .notNowTapped:
                return .none
                
            case .locationTapped:
                return .run { @MainActor send in
                    do {
                        try await locationUseCases.requestPermission()
                        send(.permissionResponse(allowed: true, error: nil))
                    } catch {
                        send(.permissionResponse(allowed: false, error: error as? LocationUseCasesError))
                    }
                }
            case let .permissionResponse(allowed, error):
                state.locationPermission = allowed ? .allowed : .denied
                if !allowed {
                    state.alert = AlertState {
                        TextState(error?.localizedDescription ?? "")
                    } actions: {
                        ButtonState(role: .none, action: .openSettingsTapped, label: { TextState("Open settings") })
                        ButtonState(role: .cancel, label: { TextState("Cancel") })
                    }
                }
                return .none
            case .alert(.presented(.openSettingsTapped)):
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
                return .none
            case .alert:
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
}
