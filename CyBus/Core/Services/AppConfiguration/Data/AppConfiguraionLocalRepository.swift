//
//  AppConfiguraionLocalRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Foundation

class AppConfiguraionLocalRepository: AppConfiguraionRepositoryProtocol {
    func fetchBackendUrl() async throws -> String {
        "https://cyprusbus.info/"
    }
    
    func fetchLanguage() -> String {
        Locale.current.language.languageCode?.identifier ?? "en"
    }
    
}
