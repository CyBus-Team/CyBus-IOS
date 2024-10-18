//
//  Store.swift
//  CyBus
//
//  Created by Vadim Popov on 16/10/2024.
//

import ComposableArchitecture

enum OnboardingPage {
    case welcome
    case geolocation
    case login
}

@Reducer
struct OnboardingFeature {
    
    static let onboardingKey = "skipOnboarding"
    
    @ObservableState
    struct State {
        var page: OnboardingPage = .welcome
        var error: String?
    }
    
    enum Action {
        case getStartTapped
        case allowLocationTapped
        case notNowGeolocationTapped
        case nextTapped
        case notNowSignInTapped
        case signInTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                //Welcome
            case .getStartTapped:
                state.page = .geolocation
                return .none
                
                //Geolocation
            case .allowLocationTapped:
                return .none
            case .nextTapped, .notNowGeolocationTapped:
                state.page = .login
                return .none
                
                //Login
            case .notNowSignInTapped:
                return .none
            case .signInTapped:
                return .none
            }
        }
    }
    
}
