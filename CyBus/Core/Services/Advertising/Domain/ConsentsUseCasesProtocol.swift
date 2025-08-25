//
//  ConsentsUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

// A generic protocol for managing consents of associated type `Consent`.
protocol ConsentsUseCasesProtocol {
    associatedtype Consent
    // Method to request consent of generic type `Consent`.
    func requestConsent() async throws -> Consent
}
