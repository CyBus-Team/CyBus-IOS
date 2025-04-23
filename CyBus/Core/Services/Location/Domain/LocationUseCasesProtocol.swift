//
//  LocationRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 03/10/2024.
//

import CoreLocation

enum LocationUseCasesError: Error, LocalizedError {
    case permissionDenied
    case locationNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return NSLocalizedString("Location permission was denied. You must enable location services in your device settings.", comment: "Error shown when location permission is denied")
        case .locationNotAvailable:
            return NSLocalizedString("Location data is currently unavailable. You must enable location services in your device settings.", comment: "Error shown when location data is not accessible")
        }
    }
}

protocol LocationUseCasesProtocol {
    
    func requestPermission() async throws
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D?

}
