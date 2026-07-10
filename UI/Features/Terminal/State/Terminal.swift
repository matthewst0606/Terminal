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

enum CommandResult {
    case exit
    case clear
    case clearline
    case text(String)
    case error(
        command: String,
        message: String
    )
}
    
struct TerminalOutput: Identifiable, Equatable {
    let id = UUID()
    let kind: Kind

    enum Kind: Equatable {
        case text(String)
        case error(command: String, message: String)
    }
}

@Observable
final class Terminal {
    var input: String = ""
    var output: [TerminalOutput] = []
    var history: [String] = []

    func submit() {
        let command = input
        let result = parseResult(RustService.shared.execute(command))

        switch result {
        case .exit: exit()
        case .clear: clear()
        case .clearline: clearline()
            
        case .text(let text):
            printPrompt(for: command)
            terminalPrint(text)
            
        case .error(let errorCommand, let message):
            printPrompt(for: command)
            output.append(.init(kind: .error(
                command: errorCommand,
                message: message
            )))
        }

        appendToHistory(command)
    }
}

struct RustCommandResult: Decodable {
    let kind: Kind
    let text: String?
    let command: String?
    let message: String?
    
    enum Kind: String, Decodable {
        case text
        case exit
        case clear
        case clearline
        case error
    }
}

extension Terminal {
    private func parseResult(_ result: String) -> CommandResult {
        guard let data = result.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(RustCommandResult.self, from: data)
        else {
            return .text(result)
        }

        switch decoded.kind {
        case .text:
            return .text(decoded.text ?? "")
        case .exit:
            return .exit
        case .clear:
            return .clear
        case .clearline:
            return .clearline
        case .error:
            return .error(
                command: decoded.command ?? "",
                message: decoded.message ?? ""
            )
        }
    }
    
    private func printPrompt(for command: String) {
        terminalPrint("\n>> \(command)\n")
    }
    
    private func terminalPrint(_ text: String) {
        output.append(.init(kind: .text(text)))
    }
    
    private func appendToHistory(_ command: String) {
        history = RustService.shared.history(command)
        input = ""
    }
    
    private func exit() {
        NSApplication.shared.terminate(nil)
    }
    
    private func clear() {
        output = []
    }
    
    private func clearline() {
        guard !output.isEmpty else { return }
        output = output.dropLast()
    }
}

