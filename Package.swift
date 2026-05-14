// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DesignSystemForIOS",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DesignSystemForIOS",
            targets: ["DesignSystemForIOS"]
        ),
    ],
    targets: [
        .target(
            name: "DesignSystemForIOS"
        ),
        .executableTarget(
            name: "DesignSystemSampleApp",
            dependencies: ["DesignSystemForIOS"],
            path: "Examples/SampleApp/Sources"
        ),
        .testTarget(
            name: "DesignSystemForIOSTests",
            dependencies: ["DesignSystemForIOS"]
        ),
    ]
)
