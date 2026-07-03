//
//  TerminalService.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import Foundation
import Combine

@MainActor
final class TerminalService: ObservableObject {
    @Published var output: String = ""
    @Published var history: [String] = []
    @Published var input: String = ""
    
    // textbox submit action
    func submit() {
        let command = input
        let result = RustService.shared.execute(command)

        if result == "__CLEAR__" {
            output = ""
        }
        else if result == "__CLEARLINE__" {
            if let lastNewLine = output.lastIndex(of: "\n") {
                output.removeSubrange(lastNewLine..<output.endIndex)
            }
            else {
                output = ""
            }
        }

        else {
            output += "\n<User> → \(command)\n"
            output += result
        }

        history.append(RustService.shared.history(command))
        input = ""
    }
        
    
    
}

