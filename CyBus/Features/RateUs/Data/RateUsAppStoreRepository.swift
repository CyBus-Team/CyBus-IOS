//
//  RateUsAppStoreRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/08/2025.
//

import StoreKit
import SwiftUICore

class RateUsAppStoreRepository: RateUsRepositoryProtocol {
    
    @MainActor func submit(review: ReviewDTO) async throws {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func hasShown() -> Bool {
        false
    }
    
}
