// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "MatTerMaster",
	platforms: [
		.macOS(.v13)
	],
	products: [
//		.executable(
//			name: "MatTerInstaller",
//			targets: ["MatTerInstaller"]
//		),
//		.executable(
//			name: "MatTerBuilder",
//			targets: ["MatTerBuilder"]
//		),
		.plugin(
			name: "MatTerBuilderPlugin",
			targets: ["MatTerBuilderPlugin"]
		)
	],
	targets: [
		.executableTarget(
			name: "MatTerInstaller",
			resources: [
				.process("Resources")
			]
		),
		.executableTarget(
			name: "MatTerBuilder",
			resources: [
				.process("Resources")
			]
		),
		.plugin(
			name: "MatTerBuilderPlugin",
			capability: .command(
				intent: .custom(
					verb: "MatterBuild",
					description: "Build a Matter target using idf.py"
				),
				permissions: [
					.allowNetworkConnections(
						scope: .all(),
						reason: "Needs to connect to ESP-idf"
					),
					.writeToPackageDirectory(
						reason: "The plugin needs to build the Matter target"
					)
				]
			),
			dependencies: [
				.target(name: "MatTerBuilder") // Add the dependency on MatTerBuilder
			]
		)
	]
)


