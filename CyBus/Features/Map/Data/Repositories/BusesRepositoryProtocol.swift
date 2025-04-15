//
//  BusesRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

protocol BusesRepositoryProtocol {
    
    func fetchBuses() async throws -> BusesDTO
    
}
