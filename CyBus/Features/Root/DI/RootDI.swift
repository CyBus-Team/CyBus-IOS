//
//  RootDI.swift
//  CyBus
//
//  Created by Vadim Popov on 25/08/2025.
//

import FactoryKit
import Foundation
import ComposableArchitecture

extension Container {
    var rootFeature: Factory<StoreOf<RootFeature>> {
        self {
            @MainActor in Store(initialState: RootFeature.State()) {
                RootFeature()
            }
        }
    }
    
}
