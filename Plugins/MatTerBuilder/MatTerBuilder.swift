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
		try buildFromTerminal(context: context)
	}
	
	func buildFromTerminal(context: PluginContext) throws{
		
		let scriptToExecute = scriptsDirectory.appendingPathComponent("MatterDevelopmentSetup.sh")
		print("Executing script at path: \(scriptToExecute.path)")
		let terminalCommand = TerminalCommand(scriptToExecute.path)
		let scriptOutput: String = try terminalCommand.execute()
		
		print("Environment setup result : \(scriptOutput)")
				
	}
	
}


#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MatTerBuilder: XcodeCommandPlugin {
	
	/// This entry point is called when operating on an Xcode project.
	func performCommand(context: XcodePluginContext, arguments: [String]) throws {
		debugPrint("Installing Matter development environtment")
	}
}
#endif


public protocol Shell{
	func execute(commandString:String) throws -> String
}

public class TerminalDriver:Shell{
	
	public init(){}
	
	public func execute(commandString:String) throws -> String{
		
		let outputPipe = Pipe()
		
		let shell = Process()
		shell.executableURL = URL(fileURLWithPath: "/bin/zsh")
		shell.arguments = ["-c", "\"\(commandString)\""] // Enclose the the command in double quotes in case it is the pathname of a script that contains spaces
		
		shell.standardInput = nil
		shell.standardOutput = outputPipe
		shell.standardError = nil
		
		try shell.run()
		shell.waitUntilExit()
		
		let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		
		return output
	}
	
	public func run(commandString:String) throws -> String{
		try execute(commandString: commandString)
	}
	
}


public class TerminalCommand{
	
	let terminal = TerminalDriver()
	let command:String
	
	public init(_ commandString:String){
		self.command = commandString
	}
	
	public func execute() throws -> String{
		try terminal.execute(commandString: self.command)
	}
	
	// Just an alias for execute()
	public func run() throws -> String{
		try execute()
	}
}
