// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Emoji",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Emoji",
            targets: ["Emoji"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "Emoji",
            dependencies: ["Swallow"],
            path: "Sources",
            resources: [
                .copy("Resources/emoji-list.json")
            ]
        ),
    ]
)
