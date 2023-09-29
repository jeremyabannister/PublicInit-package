// swift-tools-version: 5.9

///
import PackageDescription
import CompilerPluginSupport

///
let package = Package(
    name: "PublicInit-package",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        
        ///
        .library(
            name: "PublicInit-package",
            targets: ["PublicInit-package"]
        ),
        
        ///
        .executable(
            name: "PublicInit-packageClient",
            targets: ["PublicInit-packageClient"]
        ),
    ],
    dependencies: [
        
        ///
        .package(
            url: "https://github.com/apple/swift-syntax",
            from: "509.0.0"
        ),
    ],
    targets: [
        
        ///
        .macro(
            name: "PublicInit-packageMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        ///
        .target(name: "PublicInit-package", dependencies: ["PublicInit-packageMacros"]),
        
        ///
        .executableTarget(name: "PublicInit-packageClient", dependencies: ["PublicInit-package"]),
        
        ///
        .testTarget(
            name: "PublicInit-packageTests",
            dependencies: [
                "PublicInit-packageMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
