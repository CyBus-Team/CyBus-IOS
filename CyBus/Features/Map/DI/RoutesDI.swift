//
//  RoutesDI.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import Factory
import Foundation
import ComposableArchitecture

extension Container {
    var routesUseCases: Factory<RoutesUseCasesProtocol> {
        self { RoutesUseCases() }
    }
    var routesFeature: Factory<StoreOf<RoutesFeature>> {
        self {
            @MainActor in Store(initialState: RoutesFeature.State()) {
                RoutesFeature()
            }
        }
    }
}
