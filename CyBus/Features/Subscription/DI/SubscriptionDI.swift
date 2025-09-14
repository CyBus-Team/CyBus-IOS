//
//  SubscriptionDI.swift
//  CyBus
//
//  Created by Vadim Popov on 09/09/2025.
//

import FactoryKit
import Foundation
import ComposableArchitecture

extension Container {
    var subscriptionRepository: Factory<SubscriptionRepositoryProtocol> {
        self { StoreKitSubscriptionRepository() }
   }
    var subscriptionUseCases: Factory<SubscriptionUseCasesProtocol> {
        self { SubscriptionUseCases() }
    }
}
