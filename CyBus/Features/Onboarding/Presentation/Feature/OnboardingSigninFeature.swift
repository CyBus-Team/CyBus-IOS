//
//  OnboardingWelcomeFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 28/10/2024.
//

import ComposableArchitecture
import UIKit
import Foundation

@Reducer
struct OnboardingSignInFeature {
    
    @ObservableState
    struct State : Equatable {}
    
    enum Action {
        case signUpTapped
        case loginTapped
        case notNowTapped
    }
    
    @Dependency(\.onboardingUseCases) var onboardingUseCases
    
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
