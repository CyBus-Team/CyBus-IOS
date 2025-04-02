//
//  HomeDI.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Factory
import ComposableArchitecture

extension Container {
    
        var homeFeature: Factory<StoreOf<HomeFeature>> {
            self {
                @MainActor in Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                }
            }
        }
}
