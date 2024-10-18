//
//  LocationRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 03/10/2024.
//

import CoreLocation

protocol LocationUseCasesProtocol {
    
    func requestLocation()
    
    func listenChanges(onLocationUpdate: @escaping (CLLocationCoordinate2D) -> Void) async throws
}
