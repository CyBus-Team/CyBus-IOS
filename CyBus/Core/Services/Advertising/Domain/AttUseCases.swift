//
//  AttUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import Foundation
import AppTrackingTransparency

// Use case for handling App Tracking Transparency (ATT) consent.
struct AttUseCases: ConsentsUseCasesProtocol {
    // The concrete consent type for ATT.
    typealias Consent = ATTrackingManager.AuthorizationStatus

    // Method to request consent of generic type `Consent`.
    // Requests tracking authorization via `ATTrackingManager` and returns the resulting status.
    func requestConsent() async throws -> Consent {
        if #available(iOS 14, *) {
            return await ATTrackingManager.requestTrackingAuthorization()
        } else {
            // On iOS versions prior to 14, ATT dialog is unavailable; treat as authorized for compatibility
            return .authorized
        }
    }
}
