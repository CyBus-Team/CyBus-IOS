//
//  TransitFeedRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

enum BusesRepositoryError: Error {
    case invalidURL
}

class BusesRepository: BusesRepositoryProtocol {
    
    private let urlSession: URLSession
    private let bundle: Bundle
    
    init(urlSession: URLSession = .shared, bundle: Bundle = .main) {
        self.urlSession = urlSession
        self.bundle = bundle
    }
    
    func getServiceUrl() throws -> URL {
        guard let domain = Bundle.main.object(forInfoDictionaryKey: "ProductionURL") as? String else {
            throw BusesRepositoryError.invalidURL
        }
        guard let url = URL(string: domain) else {
            throw BusesRepositoryError.invalidURL
        }
        return url
    }
    
    func fetchBuses(url: URL) async throws -> [BusesDTO] {
        let (data, _) = try await urlSession.data(from: url)
        let feedMessage = try TransitRealtime_FeedMessage(serializedBytes: data)
        return feedMessage.entity
    }
    
}
