// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "QueryResolverSystem",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "QueryResolverSystem",
            targets: ["QueryResolverSystem"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.2"),
        .package(url: "https://github.com/JohnSundell/CollectionConcurrencyKit.git", from: "0.2.0"),
        .package(url: "https://github.com/alexito4/AsyncChannel.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "QueryResolverSystem",
            dependencies: [
                "AsyncChannel",
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        .testTarget(
            name: "QueryResolverSystemTests",
            dependencies: [
                "QueryResolverSystem",
                "CollectionConcurrencyKit",
            ]
        ),
    ]
)
