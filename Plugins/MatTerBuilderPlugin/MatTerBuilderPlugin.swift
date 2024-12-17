import PackagePlugin
import Foundation

@main
struct MatTerBuilder: CommandPlugin {
	
	let scriptsDirectory =  URL(fileURLWithPath: #filePath)
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.appendingPathComponent("ShellScripts")
	
	/// This entry point is called when operating on a Swift package.
	func performCommand(context: PluginContext, arguments: [String]) throws {
		
		let terminalDriver = TerminalDriver()
		guard let matterBuilderTool = try? context.tool(named: "MatTerBuilder") else {	print("tool not found");	 return}
		let matterBuilderPath = matterBuilderTool.url.path
		
		let argumentDirectory = parseArguments(arguments)
		if	let targetName = argumentDirectory["--target"],
			let target = context.package.targets.first(where: { $0.name == targetName }) as? PackagePlugin.SwiftSourceModuleTarget {
			let spmTargetDirectoryPath = target.directoryURL.path
			
			let matterTargetDirectoryPath = "\(spmTargetDirectoryPath)/Exclude/"
			let boardType = (arguments.count >= 2) ? arguments[1] : "esp32c6"
			try terminalDriver.execute(commandString: "\"\(matterBuilderPath)\" \"\(matterTargetDirectoryPath)\"")

		}
		
	}
	
	//	func buildFromTerminal(matterTarget: PackagePlugin.SwiftSourceModuleTarget, boardType: String) throws {
	//
	//		let terminalDriver = TerminalDriver()
	//		let environmentSetupScript = scriptsDirectory.appendingPathComponent("MatterDevelopmentSetup.sh")
	//		let spmTargetDirectoryPath = matterTarget.directoryURL.path
	//		let matterTargetDirectoryPath = "\(spmTargetDirectoryPath)/Exclude/"
	//		let tesExecutablePath = "\(spmTargetDirectoryPath)/.build/debug/\(matterTarget.name)"
	//		let terminalCommands = ["navigateTo \(matterTargetDirectoryPath)", "buildProjectForBoard esp32c6"]
	
	
	//		let matterBuilderPath = matterBuilderTool.path.string
	//
	//
	//		// Using the source method to source the setup script and execute the commands
	//		try terminalDriver.source(
	//			setupScript: environmentSetupScript.path,
	//			commandStrings: terminalCommands
	//		)
	//
	//	}
	
	func parseArguments(_ arguments: [String]) -> [String: String] {
		var parsedArguments: [String: String] = [:]
		var seenKeys: Set<String> = [] // Set to track seen keys
		var duplicateKeys: Set<String> = [] // Set to track duplicate keys
		
		var iterator = arguments.makeIterator()
		while let arg = iterator.next() {
			if arg.starts(with: "--") {
				if seenKeys.contains(arg) {
					// Mark this key as a duplicate and skip adding it
					duplicateKeys.insert(arg)
					continue
				}
				seenKeys.insert(arg) // Mark this key as seen
				
				if let value = iterator.next(), !value.starts(with: "--") {
					parsedArguments[arg] = value
				} else {
					parsedArguments[arg] = "" // If no value, store with empty string (optional)
				}
			}
		}
		
		// Remove any arguments with duplicate keys
		for duplicateKey in duplicateKeys {
			parsedArguments.removeValue(forKey: duplicateKey)
		}
		
		return parsedArguments
	}
	
}


#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MatTerBuilder: XcodeCommandPlugin {
	/// This entry point is called when operating on an Xcode project.
	func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
		debugPrint("Installing Matter development environtment")
	}
}
#endif


public class TerminalDriver {
	
	public init() {}
	
	// General command execution method for a single command with throttled output
	@discardableResult
	public func execute(commandString: String, throttleInterval: TimeInterval = 0.2) throws -> String {
		
		let outputPipe = Pipe()
		let shell = Process()
		shell.executableURL = URL(fileURLWithPath: "/bin/zsh")
		
		shell.arguments = ["-c", commandString]
		shell.standardOutput = outputPipe
		shell.standardError = outputPipe
		
		// Start the task
		try shell.run()
		
		let fileHandle = outputPipe.fileHandleForReading
		var output = ""
		
		// DispatchQueue to synchronize access to 'output'
		let outputQueue = DispatchQueue(label: "com.myapp.scriptOutputQueue", attributes: .concurrent)
		
		// Read asynchronously and throttle the output
		outputQueue.async {
			fileHandle.readabilityHandler = { fileHandle in
				let data = fileHandle.availableData
				if let outputString = String(data: data, encoding: .utf8), !outputString.isEmpty {
					// Use a synchronization queue to safely mutate 'output'
					DispatchQueue.main.async {
						output += outputString  // Safely mutate 'output' on the main queue
					}
					
					// Print the output in real-time
					print(outputString, terminator: "")
					
					// Throttle the output with a small delay
					Thread.sleep(forTimeInterval: throttleInterval)
				}
			}
		}
		
		// Wait for the task to finish
		shell.waitUntilExit()
		
		// Return the full output after completion
		return output
	}
	
	// Sourcing a setup script and executing multiple commands within the same shell session
	@discardableResult
	public func source(setupScript: String, commandStrings: [String], throttleInterval: TimeInterval = 0.2) throws -> String {
		
		// Join the commands with '&&' so they all execute sequentially
		let combinedCommands = commandStrings.joined(separator: " && ")
		
		// Construct the command to source the script and run the combined commands
		let sourcedCommand = "source \"\(setupScript)\" && \(combinedCommands)"
		
		// Use execute to handle the actual running, with throttling
		return try execute(commandString: sourcedCommand, throttleInterval: throttleInterval)
	}
}
