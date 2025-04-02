//
//  AppConfigurationUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

struct AppConfiguration {
    let backendURL : String
    let language : String
}

protocol AppConfigurationUseCasesProtocol {
    func setup() async throws
}
