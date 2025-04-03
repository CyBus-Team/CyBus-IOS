//
//  OnboardingDI.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Factory
import ComposableArchitecture

extension Container {
    var onboardingRepository: Factory<OnboardingRepositoryProtocol> {
        self { OnboardingRepository() }
    }
    var onboardingUseCases: Factory<OnboardingUseCasesProtocol> {
        self { OnboardingUseCases() }
    }
    var onboardingFeature: Factory<StoreOf<OnboardingFeatures>> {
        self {
            @MainActor in Store(initialState: OnboardingFeatures.State()) {
                OnboardingFeatures()
            }
        }
    }
}
