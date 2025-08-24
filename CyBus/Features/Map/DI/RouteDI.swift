//
//  RouteDI.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import FactoryKit
import Foundation
import ComposableArchitecture

extension Container {
    var routeRepository: Factory<RouteRepositoryProtocol> {
        self { RouteRepository() }
    }
    
    var routeUseCases: Factory<RouteUseCasesProtocol> {
        self { RouteUseCases() }
    }
    var routeFeature: Factory<StoreOf<RouteFeature>> {
        self {
            @MainActor in Store(initialState: RouteFeature.State()) {
                RouteFeature()
            }
        }
    }
}
