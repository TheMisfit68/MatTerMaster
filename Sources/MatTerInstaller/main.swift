//
//  main.swift
//  MatTerMaster
//
//  Created by Jan Verrept on 15/11/2024.
//

import Foundation



let terminalDriver = TerminalDriver()
let installerScript = Bundle.module.path(forResource: "MatterDevelopmentInstaller", ofType: "sh")!

try terminalDriver.execute(commandString: "\"\(installerScript)\"") // put the scripts path in double quotes to handle spaces in the path

