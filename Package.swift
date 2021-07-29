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
    targets: [
        .target(
            name: "Emoji",
            path: "Sources",
            resources: [
                .copy("Resources/emoji-list.json")
            ]
        ),
    ]
)
