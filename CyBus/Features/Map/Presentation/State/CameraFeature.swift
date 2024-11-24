//
//  CameraViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 04/10/2024.
//

import Foundation
import MapboxMaps
import ComposableArchitecture

@Reducer
struct CameraFeature {
    
    static public let maxZoom: Double = 17
    static public let minZoom: Double = 12
    static public let defaultZoom: Double = 14
    //Limassol by default
    static public let defaultLocation = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
    
    @ObservableState
    struct State: Equatable {
        var zoom: Double = CameraFeature.defaultZoom
        var viewport: Viewport = .camera(center: defaultLocation, zoom: CameraFeature.defaultZoom)
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case increaseZoom
        case decreaseZoom
        case onViewportChange(CLLocationCoordinate2D)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .onViewportChange(location):
                withViewportAnimation(.fly) {
                    state.viewport = .camera(center: location, zoom: state.zoom)
                }
                return .none
            case .increaseZoom:
                if (state.zoom < CameraFeature.maxZoom) {
                    withViewportAnimation(.fly) {
                        state.zoom += 1
                        state.viewport = .camera(zoom: state.zoom)
                    }
                }
                return .none
            case .decreaseZoom:
                if (state.zoom > CameraFeature.minZoom) {
                    withViewportAnimation(.fly) {
                        state.zoom -= 1
                        state.viewport = .camera(zoom: state.zoom)
                    }
                }
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
