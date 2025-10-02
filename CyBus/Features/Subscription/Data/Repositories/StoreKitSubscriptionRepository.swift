//
//  StoreKitSubscriptionRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 08/09/2025.
//

import StoreKit

actor StoreKitSubscriptionRepository : SubscriptionRepositoryProtocol {
    
    func restore() async throws -> [Transaction] {
        try await AppStore.sync()
        var transactions = [Transaction]()
        for await verification in Transaction.currentEntitlements {
            if case .verified(let transaction) = verification {
                transactions.append(transaction)
            } else {
                // Unverified transaction; ignore or log as needed
            }
        }
        return transactions
    }
    
    func subscribe(for productId: ProductId) async throws -> Product.PurchaseResult {
        guard let product = try await Product.products(for: [productId]).first else {
            throw NSError(domain: "Subscription", code: 1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
        }
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try verification.payloadValue
            await transaction.finish()
            // After a successful transaction, return the precise current status
            return result

        case .userCancelled, .pending:
            // Return snapshot; nothing to throw here
            return result

        @unknown default:
            return result
        }
    }
    
    
    func fetchProducts(for productIds: [ProductId]) async throws -> [Product] {
        try await Product.products(for: productIds)
    }
    
}
