// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftComponentPlayground",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftComponentPlayground",
            dependencies: [],
            path: "Sources/SwiftComponentPlayground"
        )
    ]
)
