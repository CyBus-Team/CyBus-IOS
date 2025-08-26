//
//  AdvertisingDI.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import FactoryKit
import Foundation
import ComposableArchitecture

extension Container {
    var advertisingFeature: Factory<StoreOf<AdvertisingFeature>> {
        self {
            @MainActor in Store(initialState: AdvertisingFeature.State()) {
                AdvertisingFeature()
            }
        }
    }
    var advertisingUseCases: Factory<AdvertisingUseCasesProtocol> {
        self { GoogleAdsUseCases() }.singleton
    }
    
    var attUseCases: Factory<any ConsentsUseCasesProtocol> {
        self { AttUseCases() }.singleton
    }
    
    var umpUseCases: Factory<any ConsentsUseCasesProtocol> {
        self { UmpUseCases() }.singleton
    }
}
