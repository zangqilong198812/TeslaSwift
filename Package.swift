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
        .library(name: "TeslaSwiftPromiseKit", targets: ["TeslaSwiftPMK"]),
        .library(name: "TeslaSwiftRx", targets: ["TeslaSwiftRx"])
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.0"),
        //.package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", Package.Dependency.Requirement.branch("feature/spm-support"))
    ],
    targets: [
        .target(name: "TeslaSwift", dependencies: ["Starscream"]),
        .target(name: "TeslaSwiftCombine", dependencies: ["TeslaSwift"], path: "Sources/Extensions/Combine"),
        .target(name: "TeslaSwiftPMK", dependencies: ["TeslaSwift", "PromiseKit"], path: "Sources/Extensions/PromiseKit"),
        .target(name: "TeslaSwiftRx", dependencies: ["TeslaSwift", "RxSwift", "RxCocoa"], path: "Sources/Extensions/Rx"),
        //.testTarget(name: "TeslaSwiftTests", dependencies: ["TeslaSwiftPMK", "PromiseKit", "OHHTTPStubsSwift"], path: "TeslaSwiftTests")
    ]
)
