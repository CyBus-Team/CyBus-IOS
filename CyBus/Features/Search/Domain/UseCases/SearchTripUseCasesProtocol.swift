//
//  SearchTripUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

enum SearchTripUseCasesError: Error {
    case apiNotAvailable
    case noRouteFound
    case noStartStopFound
    case noEndStopFound
    case cityNotFound
}

protocol SearchTripUseCasesProtocol {}
