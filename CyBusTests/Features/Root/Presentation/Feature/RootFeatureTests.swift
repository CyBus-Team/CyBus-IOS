//
//  RootFeatureTests.swift
//  CyBus
//
//  Created by Vadim Popov on 19/10/2024.
//

import Testing
import ComposableArchitecture
import FactoryKit

@testable import CyBus

@MainActor
struct RootFeatureTests {

    @Test("Second launch skips onboarding")
    func skipOndoarding() async {
        // GIVEN
        let skip = MockSkip()
        Container.shared.onboardingUseCases.register { skip }

        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        store.exhaustivity = .off

        // THEN
        store.assert { $0.page = .logo }
        await store.send(.initApp) {
            $0.page = .home
        }
    }

    @Test("First launch shows onboarding")
    func showOnboarding() async {
        // GIVEN
        let show = MockShow()
        Container.shared.onboardingUseCases.register { show }

        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }
        store.exhaustivity = .off
        
        // THEN
        store.assert { $0.page = .logo }
        await store.send(.initApp) {
            $0.page = .onboarding
        }
    }
}
