// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swift-acp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "ACP", targets: ["ACP"])
    ],
    targets: [
        .target(
            name: "ACP",
            path: "Sources/ACP"
        ),
        .testTarget(
            name: "ACPTests",
            dependencies: ["ACP"]
        )
    ]
)
