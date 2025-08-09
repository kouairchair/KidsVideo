// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "KidsVideo",
    platforms: [
        // ContentViewでiOS 15のAPIが使用されているため、v15を指定します
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // アプリのコア機能をライブラリとして定義します
        .library(
            name: "KidsVideoCore",
            targets: ["KidsVideoCore"]),
    ],
    dependencies: [
        // Skipの依存関係を追加します
        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "KidsVideoCore",
            dependencies: [
                .product(name: "SkipUI", package: "skip")
            ],
            // 既存のSharedディレクトリをソースコードのパスとして指定します
            path: "Shared",
            // KidsVideoApp.swiftはアプリのエントリポイントのため、ライブラリから除外します
            exclude: ["KidsVideoApp.swift"],
            resources: [
                // アセットカタログをリソースとして含めます
                .process("Assets.xcassets"),
                // Info.plistで定義されているカスタムフォントをリソースとして含めます
                // これらのファイルが "Shared" ディレクトリ直下にあることを想定しています。
                // 実際のファイルパスに合わせて調整してください。
                .copy("PenguinAttack.ttf"),
                .copy("KiwiMaru-Light.ttf")
            ],
            plugins: [
                .plugin(name: "skipstone", package: "skip")
            ]
        )
    ]
)