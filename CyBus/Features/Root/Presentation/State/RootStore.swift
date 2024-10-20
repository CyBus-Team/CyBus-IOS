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
        case goHome
        case goOnboarding
    }
    
    @Dependency(\.onboardingUseCases) var onboardingUseCases
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .initApp:
                return .run { send in
                    let needToShow = onboardingUseCases.needToShow()
                    await send(needToShow ? .goHome : .goOnboarding)
                }
            case .goHome:
                state.page = .home
                return .none
            case .goOnboarding:
                state.page = .onboarding
                return .none
            }
        }
    }
}

