//
//  OnboardingRepository.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
import Foundation
import FactoryKit

class RateUsRepository : RateUsRepositoryProtocol {
    
    func finished() {
        UserDefaults.standard.set(true, forKey: RateUsFeatures.rateUsKey)
    }
    
    func isShownBefore() -> Bool {
        UserDefaults.standard.bool(forKey: RateUsFeatures.rateUsKey)
    }
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func pushReview(for email: String, rating: Int, message: String) async throws -> Bool {
        var request = URLRequest(url: appConfiguration.backendURL.appendingPathComponent("feedback"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newReview = ReviewDTO(email: email, rating: rating, message: message);
        
        let jsonData = try JSONEncoder().encode(newReview)
        request.httpBody = jsonData

        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ReviewDTO.self, from: data)
        return decoded.email == email
    }

}
