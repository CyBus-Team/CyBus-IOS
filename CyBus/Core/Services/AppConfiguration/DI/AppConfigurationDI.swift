//
//  AppConfiguration.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Factory
import Foundation

extension Container {
    var appConfigurationRepository: Factory<AppConfiguraionRepositoryProtocol> {
        self { AppConfiguraionLocalRepository() }
   }
    var appConfigurationUseCases: Factory<AppConfigurationUseCasesProtocol> {
         self { AppConfigurationUseCases() }
    }
}
