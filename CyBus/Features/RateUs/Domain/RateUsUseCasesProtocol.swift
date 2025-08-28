//
//  RateUsUseCasesProtocol.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
protocol RateUsUseCasesProtocol {
    func finished()
    func needToShow() -> Bool
    func pushReview(for email: String, rating: Int, message: String) async throws -> Bool
}
