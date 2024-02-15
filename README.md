# LintBuildPlugin

`LintBuildPlugin` is a Swift Package Manager build tool designed to integrate SwiftFormat (lint mode) and SwiftLint build phase into your SPM projects.

## Features

- **Xcode Cloud Support**: Custom behavior for Continuous Integration environments to bypass caching for up-to-date linting results.
- **Custom Configuration Support**: Searches for `.swiftlint.yml` and '.swiftformat.yml' configuration files within your project to customize SwiftLint rules.

## Requirements

- Swift 5.9 or later.
- SwiftFormat and SwiftLint installed on your development machine or CI environment.

## Installation

1. **Add Dependency**: Include `LintBuildPlugin` in your package's dependencies within your `Package.swift`:

```swift
let package = Package(
    name: "<YourPackageName>",
    dependencies: [
        .package(url: "https://github.com/kamzab95/LintBuildPlugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "<YourTargetName>",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildPlugin", package: "LintBuildPlugin"),
                .plugin(name: "SwiftFormatBuildPlugin", package: "LintBuildPlugin")
            ]
        )
    ]
)
```

2. **Plugin Configuration**: Ensure your `Package.swift` includes the plugin products and targets configuration as demonstrated in the provided `Package.swift` snippet.

3. **Install SwiftFormat and SwiftLint**: If not already installed, ensure SwiftFormat and SwiftLint are installed on your development machine:

```bash
brew install swiftformat
brew install swiftlint
```

For CI environments, include these installation steps in your CI configuration.

## Usage

After integrating the `LintBuildPlugin`, SPM automatically executes SwiftFormat and SwiftLint during the build process. Ensure your project's root or specified directories contain `.swiftformat` and `.swiftlint.yml` configuration files for custom rules.

- **SwiftFormat**: Create a `.swiftformat` file at your project's root with your desired formatting rules.
- **SwiftLint**: Similarly, place a `.swiftlint.yml` file at your project's root or within specified directories to customize linting rules.

## Contributing

We welcome contributions and suggestions to improve `LintBuildPlugin`. Please feel free to submit issues or pull requests on our GitHub repository.

## License

`LintBuildPlugin` is available under the MIT license. See the LICENSE file for more info.
