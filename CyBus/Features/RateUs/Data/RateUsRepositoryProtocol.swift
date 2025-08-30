//
//  RateUsRepositoryProtocol.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
protocol RateUsRepositoryProtocol {
    func submit(review: ReviewDTO) async throws
    func hasShown() -> Bool
}
