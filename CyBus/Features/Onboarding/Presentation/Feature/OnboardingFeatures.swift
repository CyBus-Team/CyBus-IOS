//
//  OnboardingFeatures.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture
import FactoryKit

enum OnboardingPage {
    case welcome
    case geolocation
    case subscription
    case home
}

@Reducer
struct OnboardingFeatures {
    
    static let onboardingKey = "hasLaunchedBefore"
    
    @Injected(\.onboardingUseCases) var useCases
    
    @ObservableState
    struct State: Equatable {
        // State vars
        var page: OnboardingPage = .welcome
        var finished: Bool = false
        // Features
        var welcome = OnboardingWelcomeFeature.State()
        var geolocation = OnboardingRequestGeolocationFeature.State()
        var subscription = SubscriptionFeature.State()
    }
    
    enum Action {
        case welcome(OnboardingWelcomeFeature.Action)
        case geolocation(OnboardingRequestGeolocationFeature.Action)
        case subscription(SubscriptionFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            OnboardingWelcomeFeature()
        }
        Scope(state: \.geolocation, action: \.geolocation) {
            OnboardingRequestGeolocationFeature()
        }
        Scope(state: \.subscription, action: \.subscription) {
            SubscriptionFeature()
        }
        Reduce { state, action in
            switch action {
                
                // Welcome
            case .welcome(.getStartTapped):
                state.page = .geolocation
                return .none
                
                // Geolocation
            case .geolocation(.nextTapped), .geolocation(.notNowTapped):
                state.page = .subscription
                return .none
            case let .geolocation(.permissionResponse(allowed, _)):
                if allowed {
                    state.page = .subscription
                }
                return .none
            case .geolocation(_):
                return .none
            case .subscription(.notNowPresseed):
                useCases.finish()
                state.finished = true
                state.page = .home
                return .none
            case let .subscription(.subscribeResponse(status)):
                if (status == .success) {
                    useCases.finish()
                    state.finished = true
                    state.page = .home
                }
                return .none
            case let .subscription(.restoreResponse(status)):
                if (status == .success) {
                    useCases.finish()
                    state.finished = true
                    state.page = .home
                }
                return .none
            case .subscription:
                return .none
            }
        }
    }
}
