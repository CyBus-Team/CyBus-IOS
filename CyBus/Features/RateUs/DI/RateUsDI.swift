//
//  RateUsDI.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//

import FactoryKit
import ComposableArchitecture

extension Container {
    
    var rateUsLocalRepository: Factory<RateUsRepositoryProtocol> {
        self { RateUsLocalRepository() }
    }
    var rateUsRemoteRepository: Factory<RateUsRepositoryProtocol> {
        self { RateUsRemoteRepository() }
    }
    var rateUsAppStoreRepository: Factory<RateUsRepositoryProtocol> {
        self { RateUsAppStoreRepository() }
    }
    var rateUsUseCases: Factory<RateUsUseCasesProtocol> {
        self { RateUsUseCases() }
    }
    var rateUsFeature: Factory<StoreOf<RateUsFeature>> {
        self {
            @MainActor in Store(initialState: RateUsFeature.State()) {
                RateUsFeature()
            }
        }
    }
    
}
