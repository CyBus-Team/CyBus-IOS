//
//  CyBusApp.swift
//  CyBus
//
//  Created by Vadim Popov on 24/06/2024.
//

import SwiftUI

@main
struct CyBusApp: App {
    
    @AppStorage(ThemeKey.identifier) private var themeMode: String = ThemeKey.defaultValue.mode.rawValue
    
    private var isDark: Bool {
        get { themeMode == ThemeMode.dark.rawValue }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .environment(\.theme, isDark ? .dark : .light)
    }
}
