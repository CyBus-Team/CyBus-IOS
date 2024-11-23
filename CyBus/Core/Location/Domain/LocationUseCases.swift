//
//  LocationRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 03/10/2024.
//

import CoreLocation
import ComposableArchitecture

final class LocationUseCases : LocationUseCasesProtocol {
    
    private var location: CLLocationCoordinate2D?
    
    let locationManagerUseCases: LocationManagerUseCases
    
    init(locationManagerUseCases: LocationManagerUseCases = LocationManagerUseCases()) {
        self.locationManagerUseCases = locationManagerUseCases
    }
    
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

struct LocationUseCasesKey: DependencyKey {
    static var liveValue: LocationUseCasesProtocol = LocationUseCases()
}


extension DependencyValues {
    var locationUseCases: LocationUseCasesProtocol {
        get { self[LocationUseCasesKey.self] }
        set { self[LocationUseCasesKey.self] = newValue }
    }
}
