// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-rfc-791",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(
            name: "RFC 791",
            targets: ["RFC 791"]
        ),
        .library(
            name: "RFC 791 Standard Library Integration",
            targets: ["RFC 791 Standard Library Integration"]
        ),
        .library(
            name: "RFC 791 Foundation Integration",
            targets: ["RFC 791 Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "RFC 791",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Byte Standard Library Integration", package: "swift-byte"),
            ]
        ),
        .target(
            name: "RFC 791 Standard Library Integration",
            dependencies: [
                .target(name: "RFC 791"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .target(
            name: "RFC 791 Foundation Integration",
            dependencies: [
                .target(name: "RFC 791")
            ]
        ),
        .testTarget(
            name: "RFC 791 Tests",
            dependencies: [
                .target(name: "RFC 791"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "RFC 791 Standard Library Integration Tests",
            dependencies: [
                .target(name: "RFC 791"),
                .target(name: "RFC 791 Standard Library Integration"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "RFC 791 Foundation Integration Tests",
            dependencies: [
                .target(name: "RFC 791"),
                .target(name: "RFC 791 Foundation Integration"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
