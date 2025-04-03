//
//  RootStore.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct RootFeature {
    
    enum Page {
        case home
        case onboarding
        case logo
    }
    
    @ObservableState
    struct State : Equatable {
        var page = Page.logo
    }
    
    enum Action {
        case initApp
    }
    
    @Injected(\.onboardingUseCases) var onboardingUseCases: OnboardingUseCasesProtocol
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initApp:
                let needToShow = onboardingUseCases.needToShow()
                state.page = needToShow ? .onboarding : .home
                return .none
            }
        }
    }
}
