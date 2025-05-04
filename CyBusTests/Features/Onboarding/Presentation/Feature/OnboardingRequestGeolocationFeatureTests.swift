//
//  OnboardingRequestGeolocationFeatureTests.swift
//  CyBus
//
//  Created by Vadim Popov on 23/04/2025.
//

import Testing
import ComposableArchitecture
import Factory
import CoreLocation
import XCTest

@testable import CyBus

@MainActor
struct OnboardingRequestGeolocationFeatureTests {
    
    @Test("Permissions grant for authorized status")
    func grantPermissions() async {
        
        //GIVEN
        Container.shared.locationUseCases.register { MockGrant() }
        let store = TestStore(initialState: OnboardingRequestGeolocationFeature.State()) {
            OnboardingRequestGeolocationFeature()
        }
        store.exhaustivity = .off
        
        //WHEN
        await store.send(.locationTapped)
        
        //THEN
        await store.receive(\.permissionResponse) {
            $0.locationPermission = .allowed
        }
        
        store.assert { state in
            state.alert = nil
        }
        
    }
    
    @Test("Permissions denied for unauthorized status")
    func deniedPermissions() async {
        
        //GIVEN
        Container.shared.locationUseCases.register { MockDenied() }
        let store = TestStore(initialState: OnboardingRequestGeolocationFeature.State()) {
            OnboardingRequestGeolocationFeature()
        }
        store.exhaustivity = .off
        
        //WHEN
        await store.send(.locationTapped)
        
        //THEN
        await store.receive(\.permissionResponse) {
            $0.locationPermission = .denied
        }
        
        XCTAssertNotNil(store.state.alert)
        
    }
  
}
