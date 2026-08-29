// swift-tools-version: 6.4
import PackageDescription

extension String {
    static let rfc791 = "RFC 791"
}

extension Target.Dependency {
    static let rfc791 = Self.target(name: .rfc791)
    static let standards = Self.product(
        name: "Standard Library Extensions",
        package: "swift-standard-library-extensions"
    )
    static let binary = Self.product(name: "Binary", package: "swift-binary")
    static let binarySerializable = Self.product(
        name: "Binary Serializable",
        package: "swift-binary-serializer"
    )
    static let incits41986 = Self.product(
        name: "ASCII Serializer",
        package: "swift-ascii-serializer"
    )
    static let binaryParseable = Self.product(
        name: "Binary Parseable",
        package: "swift-binary-parser"
    )
    static let asciiParseable = Self.product(
        name: "Parseable ASCII",
        package: "swift-ascii-parser"
    )
    static let byteSLI = Self.product(
        name: "Byte Standard Library Integration",
        package: "swift-byte"
    )
}

let package = Package(
    name: "swift-rfc-791",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(name: "RFC 791", targets: ["RFC 791"]),
        .library(
            name: "RFC 791 Standard Library Integration",
            targets: ["RFC 791 Standard Library Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-serializer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii-serializer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-byte.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "RFC 791",
            dependencies: [
                .standards, .binary, .binarySerializable, .incits41986, .binaryParseable,
                .asciiParseable,
            ]
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
                "RFC 791"
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
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
