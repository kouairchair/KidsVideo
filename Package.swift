// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "KidsVideo",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "KidsVideoCore",
            targets: ["KidsVideoCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.0")
//        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "KidsVideoCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
//                .product(name: "SkipUI", package: "skip")
            ],
            path: "Shared",
//            exclude: ["KidsVideoApp.swift"],
            resources: [
                .process("Assets.xcassets"),
                .copy("PenguinAttack.ttf"),
                .copy("KiwiMaru-Light.ttf")
            ],
            plugins: [
//                .plugin(name: "skipstone", package: "skip")
            ]
        )
    ]
)
