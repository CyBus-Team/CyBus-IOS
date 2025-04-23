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

class MockGrantLocationPermissionsUseCases : LocationUseCasesProtocol {
    func requestPermission() async throws {
        return
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: 1, longitude: 1)
    }
}

class MockDeniedLocationPermissionsUseCases : LocationUseCasesProtocol {
    func requestPermission() async throws {
        throw LocationUseCasesError.permissionDenied
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        nil
    }
}

@MainActor
struct OnboardingRequestGeolocationFeatureTests {
    
    @Test
    func test_grantPermissionsForAuthorizedStatuses() async {
        
        //GIVEN
        Container.shared.locationUseCases.register { MockGrantLocationPermissionsUseCases() }
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
    
    @Test
    func test_hasAlertForDeniedStatuses() async {
        
        //GIVEN
        Container.shared.locationUseCases.register { MockDeniedLocationPermissionsUseCases() }
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
