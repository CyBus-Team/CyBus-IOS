//
//  SubscriptionFeature.swift
//  CyBus
//
//  Created by Vadim Popov on 09/09/2025.
//

import ComposableArchitecture
import FactoryKit
import StoreKit

@Reducer
struct SubscriptionFeature {

    @ObservableState
    struct State: Equatable {
        var error: String?
        var products: [SubscriptionProductEntity] = []
        var status: PurchaseStatus?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case fetchProducts
        case fetchProducsResponse([SubscriptionProductEntity])
        case fetchProducsFailure(Error)
        case subscribe(SubscriptionProductEntity)
        case subscribeResponse(PurchaseStatus)
        case subscribeFailure(Error)
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
            case let .subscribe(product):
                return .run { @MainActor send in
                    do {
                        let status = try await useCases.subscribe(product: product)
                        send(.subscribeResponse(status))
                    } catch {
                        send(.subscribeFailure(error))
                    }
                }
            case let .subscribeResponse(status):
                state.status = status
                return .none
            case let .subscribeFailure(error):
                // TODO: UI errors
                print("Error: \(error)")
                state.status = .failed
                state.error = error.localizedDescription
                return .none
            }
        }
    }

}
