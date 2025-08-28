//
//  RateUsRepositoryProtocol.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
protocol RateUsRepositoryProtocol {
    func finished()
    func isShownBefore() -> Bool
    
    func pushReview(for email: String, rating: Int, message: String) async throws -> Bool
}
