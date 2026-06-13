// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ApiKeyMenuBar",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "ApiKeyMenuBar",
            path: "ApiKeyMenuBar"
        )
    ]
)
