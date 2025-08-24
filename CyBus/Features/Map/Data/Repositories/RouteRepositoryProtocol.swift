//
//  RouteRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 23/08/2025.
//

protocol RouteRepositoryProtocol {
    
    func fetchRoute(for tripID: String) async throws -> RouteDTO
    
}
