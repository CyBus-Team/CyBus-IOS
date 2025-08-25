//
//  AdvertisingDI.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import FactoryKit
import Foundation

extension Container {
    var advertisingFeature: Factory<AdvertisingFeature> {
        self { AdvertisingFeature() }.singleton
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
