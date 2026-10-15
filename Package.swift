// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MonoLoadKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
    ],
    products: [
        .library(name: "MonoLoadKit", targets: ["MonoLoadKit"]),
    ],
    targets: [
        .target(name: "MonoLoadKit"),
        .testTarget(name: "MonoLoadKitTests", dependencies: ["MonoLoadKit"]),
    ]
)
