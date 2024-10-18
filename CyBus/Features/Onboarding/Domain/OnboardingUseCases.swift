//
//  OnboardingUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation

class OnboardingUseCases : OnboardingUseCasesProtocol {
    
    let repository: OnboardingRepositoryProtocol
    
    init(repository: OnboardingRepositoryProtocol = OnboardingRepository()) {
        self.repository = repository
    }
    
    func finish() {
        repository.finish()
    }
    
}
