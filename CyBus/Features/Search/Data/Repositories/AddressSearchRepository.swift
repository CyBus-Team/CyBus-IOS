//
//  AddressSearchRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import CoreLocation

class AddressSearchRepository: AddressSearchRepositoryProtocol {
    
    public let cyprus = "cy"
    public let format = "jsonv2"
    public let layer = "address"
    
    private let urlSession: URLSession
    
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch(query: String, userLocation: CLLocationCoordinate2D) async throws -> [SuggestionDTO] {
        var components = URLComponents(string: "https://nominatim.openstreetmap.org/search.php")
        
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "countrycodes", value: cyprus),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "layer", value: layer)
        ]
        guard let url = components?.url else {
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
