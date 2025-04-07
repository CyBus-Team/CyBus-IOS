//
//  OnboardingWelcomeFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 28/10/2024.
//

import ComposableArchitecture
import UIKit
import Foundation
import Factory

@Reducer
struct OnboardingSignInFeature {
    
    @ObservableState
    struct State : Equatable {}
    
    enum Action {
        case signUpTapped
        case loginTapped
        case notNowTapped
    }
    
    @Injected(\.onboardingUseCases) var onboardingUseCases: OnboardingUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .signUpTapped, .loginTapped, .notNowTapped:
                onboardingUseCases.finish()
                return .none
                
            }
        }
    }
    
}
