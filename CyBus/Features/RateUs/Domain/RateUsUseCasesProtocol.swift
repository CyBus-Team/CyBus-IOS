//
//  RateUsUseCasesProtocol.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
protocol RateUsUseCasesProtocol {
    func submit(email: String?, rating: Int, message: String) async throws
    func needToShow() -> Bool
}
