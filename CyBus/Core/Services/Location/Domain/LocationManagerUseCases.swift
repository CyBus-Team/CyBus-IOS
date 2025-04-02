//
//  LocationManagerUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 26/10/2024.
//

import CoreLocation

class LocationManagerUseCases : NSObject {
    
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
}

extension LocationManagerUseCases: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        guard manager.authorizationStatus != .notDetermined else {
            return
        }
        
        guard let continuation = authorizationContinuation else {
            return
        }
        
        authorizationContinuation = nil
        
        continuation.resume(returning: manager.authorizationStatus)
    }
}

extension LocationManagerUseCases : LocationManagerUseCasesProtocol {
    func getLocation() -> CLLocation? {
        locationManager.location
    }
    
    func getCurrentAuthorizationStatus() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func requestAuthorizationStatus() async -> CLAuthorizationStatus {
        
        authorizationContinuation = nil
        
        return await withCheckedContinuation { continuation in
            
            guard authorizationContinuation == nil else {
                continuation.resume(returning: locationManager.authorizationStatus)
                return
            }
            
            authorizationContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
