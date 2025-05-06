//
//  CyBusApp.swift
//  CyBus
//
//  Created by Vadim Popov on 24/06/2024.
//

import SwiftUI
import Sentry

@main
struct CyBusApp: App {
    
    init() {
        SentrySDK.start { options in
            guard let dsn = Bundle.main.object(forInfoDictionaryKey: "SentryDSN") as? String else {
                return
            }
            options.dsn = "https://\(dsn)"
            options.debug = true // Enabled debug when first installing is always helpful
            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
