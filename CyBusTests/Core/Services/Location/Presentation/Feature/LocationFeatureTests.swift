//
//  LocationFeatureTests.swift
//  CyBus
//
//  Created by Vadim Popov on 05/05/2025.
//

import Testing
import ComposableArchitecture
import FactoryKit
import CoreLocation

@testable import CyBus

@MainActor
struct LocationFeatureTests {

    @Test("Updates location when permission is granted")
    func updateCurrentLocation() async {
        // GIVEN
        let grant = MockGrant()
        Container.shared.locationUseCases.register { grant }

        let store = TestStore(initialState: LocationFeature.State()) {
            LocationFeature()
        }
        store.exhaustivity = .off

        //WHEN
        await store.send(.getCurrentLocation)
        
        //THEN
        await store.receive(\.onLocationResponse) {
            $0.location = MockGrant.mockLocation
        }
        
        store.assert { state in
            state.location = MockGrant.mockLocation
        }
    }
    
    @Test("Resets location when permission is denied")
    func resetCurrentLocation() async {
        // GIVEN
        let denied = MockDenied()
        Container.shared.locationUseCases.register { denied }

        let store = TestStore(initialState: LocationFeature.State()) {
            LocationFeature()
        }
        store.exhaustivity = .off

        //WHEN
        await store.send(.getCurrentLocation)
        
        //THEN
        await store.receive(\.onLocationResponse) {
            $0.location = nil
        }
        
        store.assert { state in
            state.location = nil
        }
    }

}
