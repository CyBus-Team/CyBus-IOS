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
    
    enum Action {
        case fetchProducts
        case fetchProducsResponse([SubscriptionProductEntity])
        case fetchProducsFailure(Error)
    }
    
    @Injected(\.subscriptionUseCases) var useCases: SubscriptionUseCasesProtocol
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchProducts:
                return .run { send in
                    do {
                        let products = try await useCases.fetchProducts()
                        await send(.fetchProducsResponse(products))
                    } catch {
                        await send(.fetchProducsFailure(error))
                    }
                }
            case let .fetchProducsResponse(products):
                state.products = products
                return .none
            case let .fetchProducsFailure(error):
                // TODO: UI errors
                print("Error: \(error)")
                state.error = error.localizedDescription
                return .none
            }
        }
    }
    
}
