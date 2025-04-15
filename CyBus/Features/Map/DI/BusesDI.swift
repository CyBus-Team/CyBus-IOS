//
//  BusesDI.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Factory
import Foundation
import ComposableArchitecture

extension Container {
    var busesRepository: Factory<BusesRepositoryProtocol> {
        self { BusesRepository() }
   }
    var busesUseCases: Factory<BusesUseCasesProtocol> {
        self { BusesUseCases() }
    }
    var busesFeature: Factory<StoreOf<BusesFeature>> {
        self {
            @MainActor in Store(initialState: BusesFeature.State()) {
                BusesFeature()
            }
        }
    }
}
