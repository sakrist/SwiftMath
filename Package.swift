// swift-tools-version:6.0
import PackageDescription

let shouldBuildForEmbedded =
    Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false


let swiftSettings: [SwiftSetting] = shouldBuildForEmbedded ? [
                .enableExperimentalFeature("Embedded"),
                .enableExperimentalFeature("Extern"),
                .define("NOSIMD"),
                .unsafeFlags([
                    "-Xfrontend", "-emit-empty-object-file",
                ]),
            ] : []

let cSettings: [CSetting] = shouldBuildForEmbedded ? [
                    .unsafeFlags(["-fdeclspec"])
                ] : []

let dependencies: [Package.Dependency] = shouldBuildForEmbedded ? [
    .package(url: "https://github.com/sakrist/emswiften", branch: "main"), ] : []

let targetDependencies: [Target.Dependency] = shouldBuildForEmbedded ? [
    "emswiften"] : []

let package = Package(
    name: "SwiftMath",
    products: [
        .library(
            name: "SwiftMath",
            targets: ["SwiftMath"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "SwiftMath",
            dependencies: targetDependencies,
            path: ".",
            exclude: ["SwiftMath.podspec", "README.md", "Tests", "LICENSE"],
            sources: ["Sources"],
            cSettings: cSettings,
            swiftSettings: [ .define("NOSIMD", .when(platforms: [.linux, .android, .windows, .wasi, ]))] 
                            + swiftSettings),
        
        .testTarget(
            name: "SwiftMathTests",
            dependencies: ["SwiftMath"]),
    ]
)
