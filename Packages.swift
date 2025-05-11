//
//  Packages.swift
//  CyBus
//
//  Created by Vadim Popov on 11/05/2025.
//

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CyBus",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "CyBus", targets: ["CyBus"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.4.3"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.50.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.15.0")
    ],
    targets: [
        .executableTarget(
            name: "CyBus",
            dependencies: [
                .product(name: "Factory", package: "Factory"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "CyBus",
            resources: [
                .process("../Config"),
                .process("../Config-Secret"),
                .process("../Localizable"),
                .process("../Generated")
            ]
        ),
        .testTarget(
            name: "CyBusTests",
            dependencies: ["CyBus"],
            path: "CyBusTests"
        )
    ]
)
