//
//  OnboardingUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation
import ComposableArchitecture
import Foundation

class OnboardingUseCases : OnboardingUseCasesProtocol {
    
    let repository: OnboardingRepositoryProtocol
    
    init(repository: OnboardingRepositoryProtocol = OnboardingRepository()) {
        self.repository = repository
    }
    
    func finish() {
        repository.finish()
    }
    
    func needToShow() -> Bool {
        repository.needToShow()
    }
}

struct OnboardingUseCasesKey: DependencyKey {
    static var liveValue: OnboardingUseCases = OnboardingUseCases()
}


extension DependencyValues {
    var onboardingUseCases: OnboardingUseCases {
        get { self[OnboardingUseCasesKey.self] }
        set { self[OnboardingUseCasesKey.self] = newValue }
    }
}
