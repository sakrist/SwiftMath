// swift-tools-version:6.0
import PackageDescription

let shouldBuildForEmbedded =
    Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false


let swiftSettings: [SwiftSetting] = shouldBuildForEmbedded ? [
                .enableExperimentalFeature("Embedded"),
                .enableExperimentalFeature("Extern"),
                .define("EMSDK"),
                .unsafeFlags([
                    "-Xfrontend", "-emit-empty-object-file",
                ]),
            ] : []

let cSettings: [CSetting] = shouldBuildForEmbedded ? [
                    .unsafeFlags(["-fdeclspec"])
                ] : []

let dependencies: [Package.Dependency] = shouldBuildForEmbedded ? [
    .package(path: "../emswiften")] : []

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
            dependencies: ["emswiften"],
            path: ".",
            exclude: ["SwiftMath.podspec", "README.md", "Tests", "LICENSE"],
            sources: ["Sources"],
            cSettings: cSettings,
            swiftSettings: [ .define("NOSIMD")] 
                            + swiftSettings),
        
        .testTarget(
            name: "SwiftMathTests",
            dependencies: ["SwiftMath"]),
    ]
)
