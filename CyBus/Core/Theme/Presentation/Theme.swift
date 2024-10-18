//
//  AppTheme.swift
//  CyBus
//
//  Created by Vadim Popov on 13/10/2024.
//

import SwiftUICore

struct Theme {
    let colors: ColorPalette
    let typography: Typography
    let mode: ThemeMode
}

enum ThemeMode: String {
    case light
    case dark
}

extension Theme {
    static let light = Theme(colors: ColorPalette.light, typography: Typography.primary, mode: .light)
    static let dark = Theme(colors: ColorPalette.dark, typography: Typography.primary, mode: .dark)
}

struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .light
    static let identifier: String = "themeMode"
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

