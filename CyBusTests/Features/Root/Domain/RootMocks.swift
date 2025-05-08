//
//  RootMocks.swift
//  CyBus
//
//  Created by Vadim Popov on 08/05/2025.
//

class MockSkip : OnboardingUseCasesProtocol {
    func finish() {}
    func needToShow() -> Bool { false }
}

class MockShow : OnboardingUseCasesProtocol {
    func finish() {}
    func needToShow() -> Bool { true }
}
