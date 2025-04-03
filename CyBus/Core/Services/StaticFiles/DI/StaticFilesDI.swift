//
//  StaticFilesDI.swift
//  CyBus
//
//  Created by Vadim Popov on 02/04/2025.
//

import Factory
import Foundation

extension Container {
    var staticFilesRepository: Factory<StaticFilesRepositoryProtocol> {
        self { StaticFilesRepository() }
   }
    var staticFilesUseCases: Factory<StaticFilesUseCasesProtocol> {
        self { StaticFilesUseCases() }
    }
}
