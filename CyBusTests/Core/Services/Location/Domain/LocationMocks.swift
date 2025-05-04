//
//  LocationMocks.swift
//  CyBus
//
//  Created by Vadim Popov on 04/05/2025.
//

import CoreLocation

class MockGrant : LocationUseCasesProtocol {
    static let mockLocation = CLLocationCoordinate2D(latitude: 1, longitude: 1)
    
    func requestPermission() async throws {
        return
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        MockGrant.mockLocation
    }
}

class MockDenied : LocationUseCasesProtocol {
    func requestPermission() async throws {
        throw LocationUseCasesError.permissionDenied
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        nil
    }
}
