import PackageDescription

let package = Package(
    name: "TeslaSwift",
	dependencies: [
		.Package(url: "https://github.com/mxcl/PromiseKit.git", versions: Version(4,0,0)..<Version(5,0,0)),
		.Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", versions: Version(2,0,0)..<Version(3,0,0))
	]
)
