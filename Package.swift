// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "MatTerMaster",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "MatTerMaster", targets: ["MatTerMaster"]),
		.plugin(
			name: "MatTerMasterTest",
			targets: ["MatTerMasterTest"]
		),
	],
	targets: [
		.target(
			name: "MatTerMaster",
			resources: [
				.copy("Resources/ShellScripts")
			]
		),
		.plugin(
			name: "MatTerMasterTest",
			capability: .command(
				intent: .custom(
					verb: "TestPlugin",
					description: "Test the plugin capabilities"
				)
			)
		)
	]
)
