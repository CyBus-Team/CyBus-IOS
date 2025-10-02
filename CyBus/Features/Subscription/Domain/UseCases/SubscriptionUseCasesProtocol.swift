//
//  SubscriptionUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 09/09/2025.
//

protocol SubscriptionUseCasesProtocol {
    func fetchProducts() async throws -> [SubscriptionProductEntity]
    func subscribe(product: SubscriptionProductEntity) async throws -> PurchaseStatus
    func restore() async throws -> PurchaseStatus
}
