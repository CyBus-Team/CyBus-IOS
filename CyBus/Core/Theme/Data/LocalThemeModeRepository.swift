//
//  LocalThemeRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import Foundation

class LocalThemeModeRepository: ThemeModeRepositoryProtocol {
    private let themeKey = ThemeKey.identifier
    
    func save(_ themeMode: ThemeMode) {
        UserDefaults.standard.set(themeMode.rawValue, forKey: themeKey)
    }
    
    func load() -> ThemeMode? {
        if let savedMode = UserDefaults.standard.string(forKey: themeKey) {
            return ThemeMode(rawValue: savedMode)
        } else {
            return nil
        }
    }
  
}
