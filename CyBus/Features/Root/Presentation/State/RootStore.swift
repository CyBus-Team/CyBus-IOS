//
//  RootStore.swift
//  CyBus
//
//  Created by Vadim Popov on 18/10/2024.
//

import ComposableArchitecture
import SwiftUI

enum RootPage {
    case logo
    case onboarding
    case home
}

@Reducer
struct RootFeature {
    
    @AppStorage(OnboardingFeature.onboardingKey) private var skipOnboarding: Bool = false
    
    @ObservableState
    struct State {
        var page: RootPage = .logo
        var error: String?
    }
    
    enum Action {
        case showLogo
        case goHome
        case goOnboarding
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .showLogo:
                return .run { send in
                    try? await Task.sleep(for: .seconds(2))
                    await send(skipOnboarding ? .goHome : .goOnboarding)
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

