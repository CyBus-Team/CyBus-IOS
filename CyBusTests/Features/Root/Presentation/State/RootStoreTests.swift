//
//  RootStoreTests.swift
//  CyBus
//
//  Created by Vadim Popov on 19/10/2024.
//

import Testing
import ComposableArchitecture

@testable import CyBus

class MockSkipOnboardingUseCase : OnboardingUseCasesProtocol {
    
    func finish() {}
    
    func needToShow() -> Bool {
        false
    }
}

class MockGoOnboardingUseCase : OnboardingUseCasesProtocol {
    
    func finish() {}
    
    func needToShow() -> Bool {
        true
    }
}

@MainActor
struct RootFeatureTests {
    
  @Test
  func showOnboarding() async {
      
      let skipOnboardingUseCase = MockSkipOnboardingUseCase()
      
      let store = TestStore(initialState: RootFeature.State()) {
          RootFeature()
      } withDependencies: {
          $0.onboardingUseCases = skipOnboardingUseCase
      }
      store.exhaustivity = .off
      
      store.assert { state in
          state.page = .logo
      }
      
      await store.send(.initApp) {
          $0.page = .home
      }
  }
    
    @Test
    func showHome() async {
        let skipOnboardingUseCase = MockGoOnboardingUseCase()
        
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        } withDependencies: {
            $0.onboardingUseCases = skipOnboardingUseCase
        }
        store.exhaustivity = .off
        
        store.assert { state in
            state.page = .logo
        }
        
        await store.send(.initApp) {
            $0.page = .onboarding
        }
    }
}
