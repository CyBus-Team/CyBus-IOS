//
//  SubscriptionProductDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 08/09/2025.
//

import StoreKit

enum SubscriptionPeriod: String, Sendable {
    case monthly   = "cybus.pro.monthly"
    case yearly    = "cybus.pro.yearly"
    case unknown
}

struct SubscriptionProductEntity: Sendable {
    let id: String
    let name: String
    let price: String
    let period: SubscriptionPeriod
    
    static func fromDTO(_ dto: Product) -> SubscriptionProductEntity {
        let period: SubscriptionPeriod
        switch dto.subscription?.subscriptionPeriod.unit {
        case .month?:
            period = .monthly
        case .year?:
            period = .yearly
        default:
            period = .unknown
        }
        return SubscriptionProductEntity(
            id: dto.id,
            name: dto.displayName,
            price: dto.displayPrice,
            period: period
        )
    }
}
