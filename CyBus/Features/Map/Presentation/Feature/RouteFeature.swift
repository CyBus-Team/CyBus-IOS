//
//  RouteFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 24/11/2024.
//

import ComposableArchitecture
import FactoryKit

@Reducer
struct RouteFeature {
    
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
        case fetchRoute(tripID: String)
        case fetchRouteResponse(RouteEntity)
        case fetchRouteError(String)
        case clearSelection
    }
    
    @Injected(\.routeUseCases) var routeUseCases: RouteUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchRoute(tripID):
                return .run { @MainActor send in
                    do {
                        let route = try await routeUseCases.getRoute(for: tripID)
                        send(.fetchRouteResponse(route))
                    } catch {
                        send(.fetchRouteError("Error: \(error.localizedDescription)"))
                    }
                }
            case let .fetchRouteError(message):
                // TODO: UI errors
                print("Error: \(message)")
                state.error = message
                return .none
            case let .fetchRouteResponse(route):
                state.selectedRoute = route
                return .none
            case .clearSelection:
                state.hasSelectedRoute.toggle()
                return .none
            }
        }
    }
    
}
