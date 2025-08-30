//
//  RateUsLocalRepository.swift
//  CyBus
//
//  Created by Artem on 5. 8. 2025..
//
import Foundation
import FactoryKit

class RateUsLocalRepository : RateUsRepositoryProtocol {
    
    static let localStorageKey = "hasShown"
    
    func submit(review: ReviewDTO) {
        UserDefaults.standard.set(true, forKey: RateUsLocalRepository.localStorageKey)
    }
    
    func hasShown() -> Bool {
        UserDefaults.standard.bool(forKey: RateUsLocalRepository.localStorageKey)
    }

}
