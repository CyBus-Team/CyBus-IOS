//
//  MapDI.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Factory
import Foundation
import ComposableArchitecture

extension Container {
    var mapFeature: Factory<StoreOf<MapFeature>> {
        self {
            @MainActor in Store(initialState: MapFeature.State()) {
                MapFeature()
            }
        }
    }
}
