//
//  HttpClient.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

class HttpClient: DataClientProtocol {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func get<T>(from path: String, type: T.Type, params: [String : String]?) async throws -> T? where T : Codable {
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        if let params = params {
            urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            throw HttpClientError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func update<T>(to path: String, type: T.Type, params: [String : String]) async throws -> T? where T : Codable {
        
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        guard let url = urlComponents?.url else {
            throw HttpClientError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
        return decodedData
    }
    
    func delete<T>(to path: String, type: T.Type, params: [String : String]?) async throws -> T? where T : Codable {
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        guard let url = urlComponents?.url else {
            throw HttpClientError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try JSONSerialization.data(withJSONObject: params ?? [], options: [])
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
        return decodedData
    }
    
}
