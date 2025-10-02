//
//  SubscriptionFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 09/09/2025.
//

import ComposableArchitecture
import FactoryKit

@Reducer
struct SubscriptionFeature {

    @ObservableState
    struct State: Equatable {
        var error: String?
        var products: [SubscriptionProductEntity] = []
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case fetchProducts
        case fetchProducsResponse([SubscriptionProductEntity])
        case fetchProducsFailure(Error)
        case notNowPresseed
    }

    @Injected(\.subscriptionUseCases) var useCases: SubscriptionUseCasesProtocol

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .notNowPresseed:
                return .none
            case .fetchProducts:
                return .run { @MainActor send in
                    do {
                        let products = try await useCases.fetchProducts()
                        send(.fetchProducsResponse(products))
                    } catch {
                        send(.fetchProducsFailure(error))
                    }
                }
            case .fetchProducsResponse(let products):
                state.products = products
                return .none
            case .fetchProducsFailure(let error):
                // TODO: UI errors
                print("Error: \(error)")
                state.error = error.localizedDescription
                return .none
            case .binding(_):
                return .none
            }
        }
    }

}
