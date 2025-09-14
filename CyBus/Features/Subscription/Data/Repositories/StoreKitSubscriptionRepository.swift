//
//  StoreKitSubscriptionRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 08/09/2025.
//

import StoreKit

actor StoreKitSubscriptionRepository : SubscriptionRepositoryProtocol {
    
    func fetchProducts(for productIds: [ProductId]) async throws -> [Product] {
        try await Product.products(for: productIds)
    }
    
}
