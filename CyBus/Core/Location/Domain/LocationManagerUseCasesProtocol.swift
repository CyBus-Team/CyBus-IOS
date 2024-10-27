//
//  LocationManagerUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 26/10/2024.
//

import CoreLocation

protocol LocationManagerUseCasesProtocol {
    
    func requestAuthorizationStatus() async -> CLAuthorizationStatus
    
    func getCurrentAuthorizationStatus() -> CLAuthorizationStatus
}
