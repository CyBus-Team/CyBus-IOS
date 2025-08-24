//
//  BusesRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import FactoryKit

class BusesRepository: BusesRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetchBuses() async throws -> [BusDTO] {
        var request = URLRequest(url: appConfiguration.backendURL.appendingPathComponent("buses"))
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode([BusDTO].self, from: data)
        return decoded
    }
    
}
