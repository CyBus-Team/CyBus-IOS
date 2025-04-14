//
//  StaticFilesDI.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Factory
import Foundation

extension Container {
    var staticFilesUseCases: Factory<StaticFilesUseCasesProtocol> {
        self { StaticFilesUseCases() }
            .singleton
    }
    var staticFilesRepository: Factory<StaticFilesRepositoryProtocol> {
        self { StaticFilesRepository() }
   }
}
