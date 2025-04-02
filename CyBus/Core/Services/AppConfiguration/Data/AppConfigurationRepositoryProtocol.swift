//
//  AppConfigurationRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

protocol AppConfiguraionRepositoryProtocol {
    func fetchBackendUrl() async throws -> String
    func fetchLanguage() -> String
}
