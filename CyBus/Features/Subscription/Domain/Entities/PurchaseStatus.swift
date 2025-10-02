//
//  PurchaseStatus.swift
//  CyBus
//
//  Created by Vadim Popov on 02/10/2025.
//

enum PurchaseStatus: Sendable, Equatable {
    case success
    case pending
    case cancelled
    case failed
}
