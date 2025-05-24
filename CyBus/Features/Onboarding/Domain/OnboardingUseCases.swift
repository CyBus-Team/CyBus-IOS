//
//  OnboardingUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation
import ComposableArchitecture
import FactoryKit

public class OnboardingUseCases : OnboardingUseCasesProtocol {
    
    @Injected(\.onboardingRepository) var repository: OnboardingRepositoryProtocol
    
    func finish() {
        repository.finish()
    }
    
    func needToShow() -> Bool {
        !repository.hasLaunchedBefore()
    }
}
