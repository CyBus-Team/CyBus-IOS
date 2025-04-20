//
//  BusesRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation
import Factory

class BusesRepository: BusesRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetchBuses() async throws -> BusesDTO {
        var request = URLRequest(url: appConfiguration.backendURL.appendingPathComponent("api/buses"))
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(BusesDTO.self, from: data)
        return decoded
    }
    
}
