//
//  OnboardingWelcomeFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 28/10/2024.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OnboardingWelcomeFeature {
    
    @ObservableState
    struct State : Equatable {}
    
    enum Action {
        case getStartTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .getStartTapped:
                return .none
                
            }
        }
    }
    
}
