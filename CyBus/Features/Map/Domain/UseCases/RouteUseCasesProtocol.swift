//
//  RouteUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import Foundation

protocol RouteUseCasesProtocol {
    
    func getRoute(for tripID: String) async throws -> RouteEntity
    
}
