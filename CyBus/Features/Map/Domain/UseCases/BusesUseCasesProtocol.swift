//
//  GFTSUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

protocol BusesUseCasesProtocol {
    
    func fetchClusters(from buses: [BusEntity], withDistance distance: Distance) -> [BusClusterEntity]
    
    func fetchBuses() async throws -> [BusEntity]
    
}
