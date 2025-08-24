//
//  AddressSearchRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import CoreLocation
import FactoryKit

class AddressSearchRepository: AddressSearchRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetch(query: String, userLocation: CLLocationCoordinate2D) async throws -> [SuggestionDTO] {
        var components = URLComponents(url: appConfiguration.backendURL.appendingPathComponent("autocomplete/search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        guard let url = components.url else {
            throw AddressSearchRepositoryError.fetchFailed
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode([SuggestionDTO].self, from: data)
        return decoded
    }
    
}
