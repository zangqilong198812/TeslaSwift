import PackageDescription

let package = Package(
    name: "TeslaSwift",
	dependencies: [
		.Package(url: "https://github.com/mxcl/PromiseKit.git", versions: Version(6,0,0)..<Version(7,0,0))
	]
)
