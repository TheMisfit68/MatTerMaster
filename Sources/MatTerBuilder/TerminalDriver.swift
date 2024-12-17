import Foundation

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
		
		// Process remaining data
		fileHandle.readabilityHandler = nil // Stop the readability handler
		let remainingData = fileHandle.availableData
		if let remainingString = String(data: remainingData, encoding: .utf8), !remainingString.isEmpty {
			output += remainingString
			print(remainingString, terminator: "")
		}
		
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
