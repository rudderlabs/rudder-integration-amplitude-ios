// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Rudder-Amplitude",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Rudder-Amplitude",
            targets: ["Rudder-Amplitude"]
        )
    ],
    dependencies: [
        .package(name: "Amplitude", url: "https://github.com/amplitude/Amplitude-iOS", from: "8.19.2"),
        .package(name: "Rudder", url: "https://github.com/rudderlabs/rudder-sdk-ios", "1.12.0"..<"2.0.0"),
    ],
    targets: [
        .target(
            name: "Rudder-Amplitude",
            dependencies: [
                .product(name: "Amplitude", package: "Amplitude"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Rudder-Amplitude",
            sources: ["Classes/"],
            publicHeadersPath: "Classes/",
            cSettings: [
                .headerSearchPath("Classes/")
            ]
        )
    ]
)
