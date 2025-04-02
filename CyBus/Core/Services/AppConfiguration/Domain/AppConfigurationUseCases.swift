//
//  AppConfigurationUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Factory

class AppConfigurationUseCases : AppConfigurationUseCasesProtocol {
    
    private let repository: AppConfiguraionRepositoryProtocol
    
    init(repository: AppConfiguraionRepositoryProtocol = Container.shared.appConfigurationRepository()) {
        self.repository = repository
    }
    
    var appConfiguration: AppConfiguration!
    
    func setup() async throws {
        let backendURL = try await repository.fetchBackendUrl()
        let language = repository.fetchLanguage()
        appConfiguration = AppConfiguration(backendURL: backendURL, language: language)
    }
    
}
