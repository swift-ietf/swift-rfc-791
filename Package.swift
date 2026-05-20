// swift-tools-version: 6.2
import PackageDescription

extension String {
    static let rfc791 = "RFC 791"
}

extension Target.Dependency {
    static let rfc791 = Self.target(name: .rfc791)
    static let standards = Self.product(name: "Standard Library Extensions", package: "swift-standard-library-extensions")
    static let binary = Self.product(name: "Binary Primitives", package: "swift-binary-primitives")
    static let binarySerializable = Self.product(name: "Binary Serializable Primitives", package: "swift-binary-serializer-primitives")
    static let incits41986 = Self.product(name: "ASCII Serializer Primitives", package: "swift-ascii-serializer-primitives")
    static let byteSLI = Self.product(name: "Byte Primitives Standard Library Integration", package: "swift-byte-primitives")
}

let package = Package(
    name: "swift-rfc-791",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(name: "RFC 791", targets: ["RFC 791"]),
        .library(name: "RFC 791 Standard Library Integration", targets: ["RFC 791 Standard Library Integration"]),
    ],
    dependencies: [
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-primitives/swift-binary-primitives"),
        .package(path: "../../swift-primitives/swift-binary-serializer-primitives"),
        .package(path: "../../swift-primitives/swift-ascii-serializer-primitives"),
        .package(path: "../../swift-primitives/swift-byte-primitives")
    ],
    targets: [
        .target(
            name: "RFC 791",
            dependencies: [.standards, .binary, .binarySerializable, .incits41986]
        ),
        .target(
            name: "RFC 791 Standard Library Integration",
            dependencies: [
                "RFC 791",
                .byteSLI,
            ]
        ),
        .testTarget(
            name: "RFC 791 Tests",
            dependencies: [
                "RFC 791",
            ]
        ),
        .testTarget(
            name: "RFC 791 Standard Library Integration Tests",
            dependencies: [
                "RFC 791",
                "RFC 791 Standard Library Integration",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
