//
//  RoutesFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 24/11/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct RoutesFeature {
    
    @ObservableState
    struct State: Equatable {
        var error: String?
        var hasSelectedRoute: Bool = false
        var selectedRoute: RouteEntity? {
            didSet {
                hasSelectedRoute = true
            }
        }
    }
    
    enum Action {
        case select(id: String)
        case clearSelection
    }
    
    @Injected(\.routesUseCases) var routesUseCases: RoutesUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .select(id):
                state.selectedRoute = routesUseCases.getRoute(for: id)
                return .none
                
            case .clearSelection:
                state.hasSelectedRoute.toggle()
                return .none
            }
        }
    }
    
}
