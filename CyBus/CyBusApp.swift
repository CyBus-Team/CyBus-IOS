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
            options.debug = true // Enabling debug when first installing is always helpful

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0

            // Configure the profiler to start profiling when there is an active root span
            // For more information, visit: https://docs.sentry.io/platforms/apple/profiling/
            options.configureProfiling = {
                $0.lifecycle = .trace
                $0.sessionSampleRate = 1.0
            }

            // Record Session Replays for 100% of Errors and 10% of Sessions
            options.sessionReplay.onErrorSampleRate = 1.0
            options.sessionReplay.sessionSampleRate = 0.1
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
