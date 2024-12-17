//
//  main.swift
//  MatTerMaster
//
//  Created by Jan Verrept on 15/11/2024.
//

import Foundation

// Parse command-line arguments for a custom test directory
let defaultTestDirectory = "$HOME/Apple-swift-matter/swift-matter-examples/led-blink"
let passedTestDirectory = CommandLine.arguments.dropFirst().first // Skip the executable name
let tempTestDirectory = passedTestDirectory ?? defaultTestDirectory

let terminalDriver = TerminalDriver()
let environmentSetupScript = Bundle.module.path(forResource: "MatterDevelopmentSetup", ofType: "sh")!
let terminalCommands = [
	"navigateTo \(tempTestDirectory)",
	"cleanBuildFolder",
	"buildProjectForBoard"
]

// Using the source method to source the setup script and execute the commands
try terminalDriver.source(
	setupScript: environmentSetupScript,
	commandStrings: terminalCommands
	)

 
