//
//  RootStore.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import ComposableArchitecture

enum RootPage {
    case logo
    case onboarding
    case home
}

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State: Equatable {
        var page: RootPage = .logo
        var error: String?
    }
    
    enum Action {
        case initApp
    }
    
    @Dependency(\.onboardingUseCases) var onboardingUseCases
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initApp:
                let needToShow = onboardingUseCases.needToShow()
                state.page = needToShow ? .onboarding : .onboarding
                return .none   
            }
        }
    }
}

