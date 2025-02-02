//
//  OnboardingUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation
import ComposableArchitecture

public class OnboardingUseCases : OnboardingUseCasesProtocol {
    
    let repository: OnboardingRepositoryProtocol
    
    init(repository: OnboardingRepositoryProtocol = OnboardingRepository()) {
        self.repository = repository
    }
    
    func finish() {
        repository.finish()
    }
    
    func needToShow() -> Bool {
        true
    }
}

struct OnboardingUseCasesKey: DependencyKey {
    static var liveValue: OnboardingUseCasesProtocol = OnboardingUseCases()
}

extension DependencyValues {
    var onboardingUseCases: OnboardingUseCasesProtocol {
        get { self[OnboardingUseCasesKey.self] }
        set { self[OnboardingUseCasesKey.self] = newValue }
    }
}
