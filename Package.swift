// swift-tools-version: 6.0
import PackageDescription

let package = Package(
	name: "MatTerMaster",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.plugin(
			name: "MatTerInstaller",
			targets: ["MatTerInstaller"]
		),
		.plugin(
			name: "MatTerBuilder",
			targets: ["MatTerBuilder"]
		),
	],
	targets: [
		.plugin(
			name: "MatTerInstaller",
			capability: .command(
				intent: .custom( verb: "MatterInstall", description: "Install the toolchain needed for Matter development")
			)
		),
		
		.plugin(
			name: "MatTerBuilder",
			capability: .command(
				intent: .custom( verb: "MatterBuild", description: "Build a Matter target using idf.py")
			)			
		)
		
	]
)
