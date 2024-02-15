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
        let cachePath = context.pluginWorkDirectory.appending(".swiftformat.cache")
        if !FileManager.default.fileExists(atPath: cachePath.string) {
            try? "".write(toFile: cachePath.string, atomically: false, encoding: .utf8)
        }

        let isRunningOnCI = ProcessInfo.processInfo.environment.keys.contains("CI_XCODE_CLOUD")
        let cache: String = isRunningOnCI ? "ignore" : cachePath.string
        let command = buildShellCommand(
            displayName: "Check SwiftFormat Availability",
            command: """
            if [[ "$(uname -m)" == arm64 ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
            fi

            if which swiftformat > /dev/null; then
            swiftformat --lint \(currentPath) --cache \(cache) || true
            else
            echo "error: SwiftFormat not installed (run: brew install swiftformat)"
            fi
            """
        )
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
}
