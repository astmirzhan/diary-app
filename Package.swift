// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "diary-app",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "DiaryCore", targets: ["DiaryCore"]),
        .executable(name: "DiaryApp", targets: ["DiaryApp"])
    ],
    targets: [
        .target(name: "DiaryCore"),
        .executableTarget(
            name: "DiaryApp",
            dependencies: ["DiaryCore"]
        ),
        .testTarget(
            name: "DiaryCoreTests",
            dependencies: ["DiaryCore"]
        )
    ]
)
