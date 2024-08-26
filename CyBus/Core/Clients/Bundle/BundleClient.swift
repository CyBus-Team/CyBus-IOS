//
//  BundleClient.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

class BundleClient: DataClientProtocol {
    
    private let bundle: Bundle
    private let fileExtension: String
    
    init(bundle: Bundle, fileExtension: String) {
        self.bundle = bundle
        self.fileExtension = fileExtension
    }
    
    func get<T>(from path: String, type: T.Type, params: [String : String]?) async throws -> T? where T : Decodable {
        guard let bundleData = bundle.url(forResource: path, withExtension: fileExtension) else {
            throw NSError(domain: "BundleClientErrorDomain", code: 1, userInfo: nil)
        }
        let data = try Data(contentsOf: bundleData)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func update<T>(to path: String, type: T.Type, params: [String : String]) async throws -> T? where T : Decodable {
        throw NSError(domain: "Unsupported Operation", code: 2, userInfo: nil)
    }
    
    func delete<T>(to path: String, type: T.Type, params: [String : String]?) async throws -> T? where T : Decodable {
        throw NSError(domain: "Unsupported Operation", code: 2, userInfo: nil)
    }
    
}
