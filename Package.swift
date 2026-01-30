// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LCPlayer",
    platforms: [
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "LCPlayer",
            targets: ["LCPlayer"]
        )
    ],
    targets: [
        .target(
            name: "LCPlayer",
            dependencies: [],
            path: "Sources/LCPlayer"
        )
    ]
)
