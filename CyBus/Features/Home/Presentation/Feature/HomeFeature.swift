//
//  HomeStore.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import ComposableArchitecture
import Factory

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State : Equatable {
        var isLoading = true
        var error = ""
    }
    
    enum Action {
        case setup
        case setupFinished
        case setupFailed(error: String)
    }
    
    let appConfugurationUseCases: AppConfigurationUseCasesProtocol = Container.shared.appConfigurationUseCases()
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setupFailed(error):
                state.isLoading = false
                state.error = error
                return .none
            case .setup:
                state.isLoading.toggle()
                return .run { @MainActor send in
                    do {
                        try await appConfugurationUseCases.setup()
                        send(.setupFinished)
                    } catch {
                        send(.setupFailed(error: error.localizedDescription))
                    }
                }
            case .setupFinished:
                state.isLoading = false
                return .none
            }
        }
    }
}
