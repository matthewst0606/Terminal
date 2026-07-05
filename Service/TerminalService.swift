//
//  TerminalService.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import Foundation
import Combine
import AppKit
import SwiftUI

@MainActor
final class TerminalService: ObservableObject {
    @Published var output = AttributedString("")
    
    @Published var history: [String] = []
    @Published var input: String = ""
    
    
    
    // textbox submit action
    func submit() {
        let command = input
        let result = RustService.shared.execute(command)

        if result.hasPrefix("__ERROR__|") {
            append("\n>> \(command)\n")
            error(result)
        } else {
            switch result {
            case "__EXIT__": exit()
            case "__CLEAR__": clear()
            case "__CLEARLINE__": clearline()
            default:
                append("\n>> \(command)\n")
                append(result)
            }
        }
        
        
        
    
        history.append(RustService.shared.history(command))
        input = ""
    }
    
    private func append(_ text: String) {
        output += AttributedString(text)
    }
    
    
    private func error(_ result: String) {
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

        var line = AttributedString("Error")
        line += AttributedString(": ")
        
        line.font = line.font?.bold()
        line.foregroundColor = .red


        var commandText = AttributedString(command)
        line.font = line.font?.bold()

        commandText.foregroundColor = .orange
        line += commandText

        line += AttributedString(", ")

        
        
        var messageText = AttributedString(message)
        messageText.font = .system(.callout).italic()

        line += messageText

        
        
        output += line
    }
    
    
    
    
    
    
    
    private func exit() {
        NSApplication.shared.terminate(nil)
    }
    
    private func clear() {
        output = AttributedString("")
    }
    
    private func clearline() {
        let plainOutput = String(output.characters)

        if let lastNewLine = plainOutput.lastIndex(of: "\n") {
            output = AttributedString(String(plainOutput[..<lastNewLine]))
        } else {
            output = AttributedString("")
        }
    }

}
