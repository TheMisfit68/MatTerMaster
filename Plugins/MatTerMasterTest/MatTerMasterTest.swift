import PackagePlugin
import Foundation

@main
struct MatTerMasterTest: CommandPlugin {
	
	/// This entry point is called when operating on a Swift package.
	func performCommand(context: PluginContext, arguments: [String]) throws {
		debugPrint("Building package with context: \(context)")
		
		try buildFromTerminal(context: context)
	}
	
	func buildFromTerminal(context: PluginContext) throws{
		debugPrint("Calling command in terminal")
	
		let output: String = "The result of some future terminal command"
		print(output)
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
