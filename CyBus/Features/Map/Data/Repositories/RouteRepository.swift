//
//  RouteRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 23/08/2025.
//

import Foundation
import FactoryKit

class RouteRepository: RouteRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetchRoute(for tripID: String) async throws -> RouteDTO {
        var components = URLComponents(url: appConfiguration.backendURL.appendingPathComponent("routes"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "tripId", value: tripID)
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(RouteDTO.self, from: data)
        return decoded
    }
    
}
