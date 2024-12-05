//
//  TransitRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

protocol BusesRepositoryProtocol {
    
    func getServiceUrl() throws -> URL
    
    func fetchBuses(url: URL) async throws -> [TransitRealtime_FeedEntity]
    
    func getLineColors() throws -> [String: String]
}
