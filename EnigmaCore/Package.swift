// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EnigmaCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "EnigmaCore", targets: ["EnigmaCore"]),
        .executable(name: "EnigmaCLI", targets: ["EnigmaCLI"])
    ],
    targets: [
        .target(name: "EnigmaCore"),
        .executableTarget(name: "EnigmaCLI", dependencies: ["EnigmaCore"]),
        .testTarget(name: "EnigmaCoreTests", dependencies: ["EnigmaCore"])
    ]
)
