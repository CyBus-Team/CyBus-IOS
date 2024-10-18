//
//  LocationRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/10/2024.
//

import CoreLocation

enum LocationUseCasesError: Error {
    case permissionDenied
    case locationNotAvailable
}

final class LocationUseCases : LocationUseCasesProtocol {
    
    private var location: CLLocationCoordinate2D?
    
    private let locationManager: CLLocationManager
    
    init() {
        self.locationManager = CLLocationManager()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        if let currentLocation = location {
            return currentLocation
        } else if (locationManager.authorizationStatus != .authorizedAlways || locationManager.authorizationStatus != .authorizedWhenInUse) {
            throw LocationUseCasesError.permissionDenied
        } else {
            throw LocationUseCasesError.locationNotAvailable
        }
    }
    
    func listenChanges(onLocationUpdate: @escaping (CLLocationCoordinate2D) -> Void) async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            if let location = locationUpdate.location {
                let coordinate = CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                onLocationUpdate(coordinate)
            }
        }
    }
    
}
