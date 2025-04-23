//
//  LocationRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/10/2024.
//

import CoreLocation
import ComposableArchitecture
import Factory

final class LocationUseCases : LocationUseCasesProtocol {
    
    private var location: CLLocationCoordinate2D?
    
    @Injected(\.locationManagerUseCases) var locationManagerUseCases: LocationManagerUseCasesProtocol
    
    func requestPermission() async throws {
        let status = locationManagerUseCases.getCurrentAuthorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            throw LocationUseCasesError.permissionDenied
        case .notDetermined:
            let result = await locationManagerUseCases.requestAuthorizationStatus()
            if result != .authorizedAlways && result != .authorizedWhenInUse && result != .notDetermined {
                throw LocationUseCasesError.permissionDenied
            }
        @unknown default:
            throw LocationUseCasesError.permissionDenied
        }
        
        
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        let status = locationManagerUseCases.getCurrentAuthorizationStatus()
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            let updatedLocation = locationManagerUseCases.getLocation()?.coordinate
            guard updatedLocation?.latitude != nil && updatedLocation?.longitude != nil else {
                return location
            }
            return updatedLocation
        } else if (status != .authorizedAlways || status != .authorizedWhenInUse) {
            throw LocationUseCasesError.permissionDenied
        } else {
            throw LocationUseCasesError.locationNotAvailable
        }
    }
    
}
