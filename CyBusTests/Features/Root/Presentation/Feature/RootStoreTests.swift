//
//  RootStoreTests.swift
//  CyBus
//
//  Created by Vadim Popov on 19/10/2024.
//

import Testing
import ComposableArchitecture
import Factory

@testable import CyBus

class MockSkipOnboardingUseCase : OnboardingUseCasesProtocol {
    
    func finish() {}
    
    func needToShow() -> Bool {
        false
    }
}

class MockShowOnboardingUseCase : OnboardingUseCasesProtocol {
    
    func finish() {}
    
    func needToShow() -> Bool {
        true
    }
}

@MainActor
struct RootFeatureTests {
    
    @Test
    func test_navigatesToHome_whenShouldSkipOnboarding() async {
        // GIVEN
        let skipOnboardingUseCase = MockSkipOnboardingUseCase()
        Container.shared.onboardingUseCases.register { skipOnboardingUseCase }

        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        store.exhaustivity = .off

        // WHEN
        store.assert { state in
            state.page = .logo
        }

        // THEN
        await store.send(.initApp) {
            $0.page = .home
        }
    }
    
    @Test
    func test_navigatesToOnboarding_whenShouldShowOnboarding() async {
        // GIVEN
        let showOnboardingUseCase = MockShowOnboardingUseCase()
        Container.shared.onboardingUseCases.register { showOnboardingUseCase }

        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        store.exhaustivity = .off

        // WHEN
        store.assert { state in
            state.page = .logo
        }

        // THEN
        await store.send(.initApp) {
            $0.page = .onboarding
        }
    }
}
