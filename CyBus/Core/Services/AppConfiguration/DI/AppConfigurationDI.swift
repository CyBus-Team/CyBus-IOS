//
//  AppConfiguration.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import Factory
import Foundation

struct AppConfiguration {
    let backendURL: URL
    let language: String
}

extension Container {
    var appConfiguration: Factory<AppConfiguration> {
        self { AppConfiguration(backendURL: URL(string: "https://cyprusbus.info/")!, language: "en") }
    }
}
