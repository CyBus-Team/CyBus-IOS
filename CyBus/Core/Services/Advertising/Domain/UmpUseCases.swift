//
//  UmpUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import Foundation
import UserMessagingPlatform

// Use case for handling User Messaging Platform (UMP) consent.
struct UmpUseCases: ConsentsUseCasesProtocol {
    // The concrete consent type for UMP.
    typealias Consent = ConsentStatus

    // Method to request consent of generic type `Consent`.
    // Calls UMP to update consent info and loads/presents the form if required, then returns `consentStatus`.
    func requestConsent() async throws -> Consent {
        try await withCheckedThrowingContinuation { continuation in
            let params = RequestParameters()
            // Per Google docs, call this on every app launch before checking consentStatus or loading a form.
            ConsentInformation.shared.requestConsentInfoUpdate(with: params) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                // Loads and presents a form if required; otherwise completes immediately.
                ConsentForm.loadAndPresentIfRequired(from: nil) { _ in
                    let status = ConsentInformation.shared.consentStatus
                    continuation.resume(returning: status)
                }
            }
        }
    }
}
