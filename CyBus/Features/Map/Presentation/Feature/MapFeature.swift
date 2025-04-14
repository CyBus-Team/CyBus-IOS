//
//  MapFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 29/10/2024.
//

import ComposableArchitecture
import MapboxMaps
import UIKit
import Factory

@Reducer
struct MapFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        // Features
        var userLocation = LocationFeature.State()
        var search = SearchFeatures.State()
        
        //State vars
        var error: String?
        var isLoading: Bool = true
        
    }
    
    enum Action {
        case userLocation(LocationFeature.Action)
        case search(SearchFeatures.Action)
        
        case setUp
        
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case openSettingsTapped
        }
    }
    
    @Injected(\.mapUseCases) var mapUseCases: MapUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Scope(state: \.userLocation, action: \.userLocation) {
            LocationFeature()
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
                
            case .alert(.presented(.openSettingsTapped)):
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
                return .none
            case let .search(.searchAddressResult(.setup(suggestion))):
                return .none
//                return .run { send in
//                    await send(.mapCamera(.onViewportChange(suggestion!.location)))
//                }
            case let .search(.searchAddressResult(.onGetDirectionsResponse(nodes))):
//                return .run { send in
//                    if let node = nodes.first {
//                        await send(.mapCamera(.onViewportChange(node.location)))
//                    }
//                }
                return .none
            case .alert(_), .userLocation(_), .search(_):
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
    
}
