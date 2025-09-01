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
        self {
            #if DEBUG
            return AppConfiguration(
                backendURL: URL(string: "https://api.cybusapp.org/")!,
                bannerAdUnitID: "ca-app-pub-3940256099942544/2934735716",
                interstitialAdUnitID: "ca-app-pub-3940256099942544/4411468910"
            )
            #else
            return AppConfiguration(
                backendURL: URL(string: "https://api.cybusapp.org/")!,
                bannerAdUnitID: "ca-app-pub-4424393069629810/9860491144",
                interstitialAdUnitID: "ca-app-pub-4424393069629810/2173572817"
            )
            #endif
        }
    }
}
