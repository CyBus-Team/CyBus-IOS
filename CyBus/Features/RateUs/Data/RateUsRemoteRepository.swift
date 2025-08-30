//
//  RateUsRemoteRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/08/2025.
//

import Foundation
import FactoryKit

class RateUsRemoteRepository : RateUsRepositoryProtocol {

    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func submit(review: ReviewDTO) async throws {
        var request = URLRequest(url: appConfiguration.backendURL.appendingPathComponent("feedback"))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // Build x-www-form-urlencoded body: email, rating, message
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "email", value: review.email),
            URLQueryItem(name: "rating", value: String(review.rating)),
            URLQueryItem(name: "message", value: review.message)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        let (data, response) = try await urlSession.data(for: request)
        if let http = response as? HTTPURLResponse, [200,201,204].contains(http.statusCode) {
            return
        } else {
            #if DEBUG
            if let http = response as? HTTPURLResponse {
                print("RateUsRemoteRepository: status=", http.statusCode)
            }
            if let body = String(data: data, encoding: .utf8) {
                print("RateUsRemoteRepository: response body=\n", body)
            }
            #endif
            throw URLError(.badServerResponse)
        }
        
    }
    
    func hasShown() -> Bool {
        true
    }
    
}
