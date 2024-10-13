//
//  ThemeUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

class ThemeModeUseCases : ThemeModeUseCasesProtocol {
    private let repository: ThemeModeRepositoryProtocol
    
    init(repository: ThemeModeRepositoryProtocol = LocalThemeModeRepository()) {
        self.repository = repository
    }
    
    func save(_ mode: ThemeMode) {
        repository.save(mode)
    }
    
    func load() -> ThemeMode {
        repository.load() ?? ThemeKey.defaultValue.mode
    }
    
}
