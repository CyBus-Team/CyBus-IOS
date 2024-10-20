//
//  OnboardingLocalRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation

class OnboardingRepository : OnboardingRepositoryProtocol {
    
    func finish() {
        UserDefaults.standard.set(true, forKey: OnboardingFeature.onboardingKey)
    }
    
    func needToShow() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingFeature.onboardingKey)
    }
    
}
