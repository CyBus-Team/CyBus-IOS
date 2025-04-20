//
//  LocationDI.swift
//  CyBus
//
//  Created by Vadim Popov on 07/04/2025.
//

import Factory
import Foundation

extension Container {
    var locationManagerUseCases: Factory<LocationManagerUseCasesProtocol> {
        self { LocationManagerUseCases() }.singleton
    }
    var locationUseCases: Factory<LocationUseCasesProtocol> {
        self { LocationUseCases() }.singleton
    }
}
