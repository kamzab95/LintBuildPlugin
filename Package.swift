// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LintBuildPlugin",
    products: [
        .plugin(
            name: "SwiftLintBuildPlugin",
            targets: ["SwiftLintBuildPhase"]
        ),
        .plugin(
            name: "SwiftFormatBuildPlugin",
            targets: ["SwiftFormatBuildPhase"]
        )
    ],
    targets: [
        .plugin(
            name: "SwiftFormatBuildPhase",
            capability: .buildTool(),
            path: "Plugins/SwiftFormatBuildPhase"
        ),
        .plugin(
            name: "SwiftLintBuildPhase",
            capability: .buildTool(),
            path: "Plugins/SwiftLintBuildPhase"
        )
    ]
)
