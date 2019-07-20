// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TeslaSwift",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .watchOS(.v3), .tvOS(.v10)
    ],
    products: [
        .library(name: "TeslaSwift", targets: ["TeslaSwift"]),
        .library(name: "TeslaSwiftCombine", targets: ["TeslaSwiftCombine"]),
        .library(name: "TeslaSwiftPromiseKit", targets: ["TeslaSwiftPMK"])
    ],
    dependencies: [
    .package(url: "https://github.com/mxcl/PromiseKit", from: "6.0.0")
    ],
    targets: [
        .target(name: "TeslaSwiftCombine", dependencies: ["TeslaSwift"], path: "Sources/Extensions/Combine"),
        .target(name: "TeslaSwiftPMK", dependencies: ["TeslaSwift", "PromiseKit"], path: "Sources/Extensions/PromiseKit"),
        .target(name: "TeslaSwift"),
        /*.testTarget(
         name: "TeslaSwiftTests",
         dependencies: ["TeslaSwift"],
         path: "TeslaSwiftTests"
         )*/
    ]
)
