//
//  AppConfiguration.swift
//  CyBus
//
//  Created by Vadim Popov on 26/03/2025.
//

import FactoryKit
import Foundation

struct AppConfiguration {
    // Base URL of the backend API used for network requests.
    let backendURL: URL
    // AdMob unit ID for banner advertisements.
    let bannerAdUnitID: String
    // AdMob unit ID for interstitial video advertisements.
    let interstitialAdUnitID: String
}

extension Container {
    var appConfiguration: Factory<AppConfiguration> {
        self { AppConfiguration(
            backendURL: URL(string: "https://api.cybusapp.org/")!,
            bannerAdUnitID: "ca-app-pub-3940256099942544/6300978111",
            interstitialAdUnitID: "ca-app-pub-3940256099942544/8691691433")
        }
    }
}
