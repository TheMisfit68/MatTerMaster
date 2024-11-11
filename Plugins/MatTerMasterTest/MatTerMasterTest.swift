import PackagePlugin
import Foundation

@main
struct MatTerMasterTest: CommandPlugin {
	
	/// This entry point is called when operating on a Swift package.
	func performCommand(context: PluginContext, arguments: [String]) throws {		
		try buildFromTerminal(context: context)
	}
	
	func buildFromTerminal(context: PluginContext) throws{
		let buildDirectory = context.package.directoryURL
		print("Performing action on current build: \(buildDirectory)")
		
		let terminalOutput: String = "The result of some future terminal command"
		print(terminalOutput)
	}
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MatTerMasterTest: XcodeCommandPlugin {
	
	/// This entry point is called when operating on an Xcode project.
	func performCommand(context: XcodePluginContext, arguments: [String]) throws {
		debugPrint("Building project with context: \(context)")
	}
}
#endif
