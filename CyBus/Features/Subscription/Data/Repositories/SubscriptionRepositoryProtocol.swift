//
//  SubscriptionRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 08/09/2025.
//

import StoreKit

typealias ProductId = String

protocol SubscriptionRepositoryProtocol {
    func fetchProducts(for productIds: [ProductId]) async throws -> [Product]
    func subscribe(for productId: ProductId) async throws -> Product.PurchaseResult 
}
