//
//  SearchTripRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import Foundation
import FactoryKit
import CoreLocation

class SearchTripRepository: SearchTripRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetchTrips(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, date: Date) async throws -> TripResponseDTO {
        var components = URLComponents(url: appConfiguration.backendURL.appendingPathComponent("trip"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "fromLatitude", value: String(from.latitude)),
            URLQueryItem(name: "fromLongitude", value: String(from.longitude)),
            URLQueryItem(name: "toLongitude", value: String(to.longitude)),
            URLQueryItem(name: "toLatitude", value: String(to.latitude)),
            URLQueryItem(name: "dateTime", value: date.ISO8601Format()),
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

        let decoder = JSONDecoder()
        let tripResponse = try decoder.decode(TripResponseDTO.self, from: data)
        return tripResponse
    }
    
}
