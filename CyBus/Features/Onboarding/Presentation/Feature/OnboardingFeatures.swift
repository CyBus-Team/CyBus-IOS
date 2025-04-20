//
//  OnboardingFeatures.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture

enum OnboardingPage {
    case welcome
    case geolocation
    case home
}

@Reducer
struct OnboardingFeatures {
    
    static let onboardingKey = "hasLaunchedBefore"
    
    @ObservableState
    struct State: Equatable {
        // State vars
        var page: OnboardingPage = .welcome
        var finished: Bool = false
        // Features
        var welcome = OnboardingWelcomeFeature.State()
        var geolocation = OnboardingRequestGeolocationFeature.State()
    }
    
    enum Action {
        case welcome(OnboardingWelcomeFeature.Action)
        case geolocation(OnboardingRequestGeolocationFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            OnboardingWelcomeFeature()
        }
        Scope(state: \.geolocation, action: \.geolocation) {
            OnboardingRequestGeolocationFeature()
        }
        Reduce { state, action in
            switch action {
                
                // Welcome
            case .welcome(.getStartTapped):
                state.page = .geolocation
                return .none
                
                // Geolocation
            case .geolocation(.nextTapped), .geolocation(.notNowTapped):
                state.finished = true
                state.page = .home
                return .none
            case let .geolocation(.permissionResponse(allowed, _)):
                if allowed {
                    state.finished = true
                    state.page = .home
                }
                return .none
            case .geolocation(_):
                return .none
                
            }
        }
    }
}
