//
//  RateUsDI.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//

import FactoryKit
import ComposableArchitecture

extension Container {
    
    var rateUsRepository: Factory<RateUsRepositoryProtocol> {
        self { RateUsRepository() }
    }
    var rateUsUseCases: Factory<RateUsUseCasesProtocol> {
        self { RateUsUseCases() }
    }
    var rateUsFeature: Factory<StoreOf<RateUsFeatures>> {
        self {
            @MainActor in Store(initialState: RateUsFeatures.State()) {
                RateUsFeatures()
            }
        }
    }
}
