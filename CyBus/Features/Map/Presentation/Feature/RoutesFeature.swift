//
//  RoutesFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 24/11/2024.
//

import ComposableArchitecture

@Reducer
struct RoutesFeature {
    
    @ObservableState
    struct State: Equatable {
        var isSetUp: Bool = false
        var error: String?
        var hasSelectedRoute: Bool = false
        var selectedRoute: BusRouteEntity? {
            didSet {
                hasSelectedRoute = true
            }
        }
    }
    
    enum Action {
        case setUp
        case setUpResponse(Bool, error: String?)
        
        case select(id: String)
        case clearSelection
    }
    
    @Dependency(\.routesUseCases) var routesUseCases
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setUp:
                return .run { @MainActor send in
                    do {
                        try await routesUseCases.fetchRoutes()
                        return send(.setUpResponse(true, error: nil))
                    } catch {
                        return send(.setUpResponse(false, error: error.localizedDescription))
                    }
                }
                
            case let .setUpResponse(success, error):
                state.isSetUp = success
                state.error = error
                return .none
             
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
