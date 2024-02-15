//
//  Created by Kamil Zaborowski on 12/02/2024.
//  Copyright © Kamil Zaborowski 2024. All Rights Reserved.
//

import Foundation
import PackagePlugin

@main
struct LintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let currentPath = target.directory.string
        let startDirectory = URL(filePath: context.package.directory.string)
        let isRunningOnCI = ProcessInfo.processInfo.environment.keys.contains("CI_XCODE_CLOUD")
        let cacheCommand = isRunningOnCI ? "--no-cache" : ""
        let command: Command =
            if let configFile = findFile(fileName: ".swiftlint.yml", in: startDirectory, maxDepth: 3) {
                buildShellCommand(
                    displayName: "Check SwiftLint Availability",
                    command: """
                    if [[ "$(uname -m)" == arm64 ]]; then
                    export PATH="/opt/homebrew/bin:$PATH"
                    fi

                    if which swiftlint > /dev/null; then
                    swiftlint lint \"\(currentPath)\" --config \"\(configFile)\" \(cacheCommand) || true
                    else
                    echo "error: SwiftLint not installed (run: brew install swiftlint)"
                    fi
                    """
                )
            } else {
                buildShellCommand(
                    displayName: "Check SwiftLint Availability",
                    command: """
                    echo "error: .swiftlint.yml not found"
                    """
                )
            }
        return [command]
    }

    private func buildShellCommand(displayName: String, command: String) -> Command {
        Command.buildCommand(
            displayName: displayName,
            executable: Path("/bin/sh"),
            arguments: ["-c", command],
            environment: [:]
        )
    }

    private func findFile(fileName: String, in directory: URL, maxDepth: Int) -> String? {
        var currentDirectory = directory
        var depth = 0
        while true {
            depth += 1
            if depth > maxDepth {
                break
            }
            let swiftLintFilePath = currentDirectory.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: swiftLintFilePath.path) {
                return swiftLintFilePath.path
            }
            currentDirectory.deleteLastPathComponent()
        }
        return nil
    }
}
