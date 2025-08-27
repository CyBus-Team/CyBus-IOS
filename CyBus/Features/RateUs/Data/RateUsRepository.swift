//
//  OnboardingRepository.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
import Foundation

class RateUsRepository : RateUsRepositoryProtocol {
    
    func finished() {
        UserDefaults.standard.set(true, forKey: RateUsFeatures.rateUsKey)
    }
    
    func isShownBefore() -> Bool {
        UserDefaults.standard.bool(forKey: RateUsFeatures.rateUsKey)
    }
    
}
