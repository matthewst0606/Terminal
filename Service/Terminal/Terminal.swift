//
//  TerminalService.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import Observation
import Foundation
import AppKit
import SwiftUI

@Observable
final class Terminal {
    var input: String = ""
    var output = AttributedString("")
    var history: [String] = []
    
    // textbox submit action
    func submit() {
        let command = input
        let result = RustService.shared.execute(command)

        
        if result.hasPrefix("__ERROR__|") {
            terminalPrint("\n>> \(command)\n")
            printError(result)
        }
        else {
            switch result {
            case "__EXIT__": exit()
            case "__CLEAR__": clear()
            case "__CLEARLINE__": clearline()
            default:
                terminalPrint("\n>> \(command)\n")
                terminalPrint(result)
            }
        }
        

        appendToHistory(command)
    }
}

// output based on builtin commands
extension Terminal {
    private func exit() {
        NSApplication.shared.terminate(nil)
    }
    
    private func clear() {
        output = AttributedString("")
    }
    
    private func clearline() {
        let plainOutput = String(output.characters)

        if let lastNewLine = plainOutput.lastIndex(of: "\n") {
            output = AttributedString(
                String(plainOutput[..<lastNewLine])
            )
        }
        else {
            output = AttributedString("")
        }
    }
}

extension Terminal {
    private func appendToHistory(_ command: String) {
        history = RustService.shared.history(command)
        input = ""
    }

    private func terminalPrint(_ text: String) {
        output += AttributedString(text)
    }
    
    private func printError(_ result: String) {
        let parts = result.split(
            separator: "|",
            maxSplits: 2,
            omittingEmptySubsequences: false
        )
        
        guard parts.count == 3, parts.first == "__ERROR__" else {
            output += AttributedString(result)
            return
        }
        let command = String(parts[1])
        let message = String(parts[2])

        
        
        var errorString = AttributedString("Error: ")
        errorString.font = errorString.font?.bold()
        errorString.foregroundColor = .red

        var inputCommand = AttributedString(command)
        inputCommand.font = inputCommand.font?.bold()
        inputCommand.foregroundColor = .orange

        var errorMessage = AttributedString(", \(message)")
        errorMessage.font = .system(.callout).italic()
        
        
        
        errorString += inputCommand
        errorString += errorMessage
        output += errorString
    }
}
