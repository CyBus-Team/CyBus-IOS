//
//  BaseApiClient.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

protocol DataClientProtocol {
    
    func get<T: Codable>(
        from path: String,
        type: T.Type,
        params: [String: String]?
    ) async throws -> T?
    
    func update<T: Codable>(
        to path: String,
        type: T.Type,
        params: [String: String]
    ) async throws -> T?
    
    func delete<T: Codable>(
        to path: String,
        type: T.Type,
        params: [String: String]?
    ) async throws -> T?
    
}
