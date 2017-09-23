import PackageDescription

let package = Package(
    name: "TeslaSwift",
	dependencies: [
		.Package(url: "https://github.com/mxcl/PromiseKit.git", versions: Version(4,0,0)..<Version(5,0,0))
	]
)
