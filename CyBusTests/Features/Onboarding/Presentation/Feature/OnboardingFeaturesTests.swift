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

@MainActor
struct OnboardingFeaturesTests {
    
    @Test
    func test_initialPageIsWelcome() async {
        
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
    
    @Test
    func test_navigatesToGeolocationPageAfterGetStarted() async {
        
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

    @Test
    func test_finishesOnboardingAfterNextTapped() async {
        
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
    
    @Test
    func test_finishesOnboardingAfterSkipedGeolocation() async {
        
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
    
    @Test
    func test_finishesOnboardingWhenAllowPermissions() async {
        
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
    
    @Test
    func test_StayGeolocationPageWhenPermissionsAreNotAllowed() async {
        
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
}
