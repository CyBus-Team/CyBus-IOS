//
//  OnboardingFeaturesTests.swift
//  CyBus
//
//  Created by Vadim Popov on 22/04/2025.
//

import Testing
import ComposableArchitecture
import Factory

@testable import CyBus

class MockOnboardingUseCases : OnboardingUseCasesProtocol {
    var finishOnboardingCallCount = 0
    
    func finish() {
        finishOnboardingCallCount += 1
    }
    
    func needToShow() -> Bool {
        return true
    }
    
}

@MainActor
struct OnboardingFeaturesTests {
    
    @Test("Initial page is welcome")
    func initialPageIsWelcome() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // THEN
        store.assert { state in
            state.page = .welcome
            state.finished = false
        }
    }
    
    @Test("Second page is geolocation")
    func secondPageIsWelcome() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))

        // THEN
        store.assert { state in
            state.page = .geolocation
            state.finished = false
        }
    }

    @Test("Onboarding finishes after next page")
    func finishOnboarding() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))
        await store.send(.geolocation(.nextTapped))
        
        //THEN
        store.assert { state in
            state.page = .home
            state.finished = true
        }
    }
    
    @Test("Skip geolocation and finish onboarding")
    func skipGeolocation() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))
        await store.send(.geolocation(.notNowTapped))
        
        //THEN
        store.assert { state in
            state.page = .home
            state.finished = true
        }
    }
    
    @Test("Onboarding finishes when permissions are allowed")
    func finishOnboardingWithPermissions() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))
        await store.send(.geolocation(.permissionResponse(allowed: true, error: nil)))
        
        //THEN
        store.assert { state in
            state.page = .home
            state.finished = true
        }
    }
    
    @Test("Onboarding stays on geolocation page when permissions are not allowed")
    func finishOnboardingWitoutPermissions() async {
        
        // GIVEN
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))
        await store.send(.geolocation(.permissionResponse(allowed: false, error: nil)))
        
        //THEN
        store.assert { state in
            state.page = .geolocation
            state.finished = false
        }
    }
    
    @Test("Onboarding use cases method executes more than once")
    func onboardingUseCasesExecutes() async {
        
        // GIVEN
        let useCase = MockOnboardingUseCases()
        Container.shared.onboardingUseCases.register { useCase }
        let store = TestStore(initialState: OnboardingFeatures.State()) {
            OnboardingFeatures()
        }
        store.exhaustivity = .off

        // WHEN
        await store.send(.welcome(.getStartTapped))
        await store.send(.geolocation(.permissionResponse(allowed: true, error: nil)))
        
        //THEN
        #expect(useCase.finishOnboardingCallCount > 0)
    }
    
}
