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

struct TerminalOutput: Identifiable, Equatable {
    let id = UUID()
    let kind: Kind

    enum Kind: Equatable {
        case text(String)
        case listing(entries: [DirectoryEntry])
        case gitStatus(
            branch: String,
            branchStatus: String,
            entries: [GitStatusEntry]
        )
        
        case dockePs(
            entries: [DockerPsEntry]
        )
        case error(command: String, message: String)
    }
}

@Observable
final class Terminal {
    var input: String = ""
    var output: [TerminalOutput] = []
    private static let historyKey = "terminalHistory"
    var currentDir = ""
    
    
    
    
    var history: [String] = UserDefaults
        .standard
        .stringArray(forKey: "terminalHistory") ?? []

    
    func submit() {
        submitType(prompt: true)
        refreshDir()

    }

    func submitNoPrompt(_ command: String) {
        input = command
        submitType(prompt: false)
        refreshDir()
    }
    
    private func submitType(prompt: Bool) {
        let command = input
        let result = parseResult(RustService.shared.execute(command))
        
        switch result {
        case .exit:
            exit()
            
        case .clear:
            clear()
            
        case .clearline:
            clearline()
            
        case .listing(let entries):
            promptUserInput(prompt: prompt, command: command)
            outputList(command: command, entries: entries)
            
        case .text(let text):
            promptUserInput(prompt: prompt, command: command)
            outputText(text)
        
            
        case .gitStatus(let branch, let branchStatus, let entries):
            promptUserInput(prompt: prompt, command: command)
            outputGitStatus(
                branch: branch,
                branchStatus: branchStatus,
                entries: entries
            )

        case .dockerPs(let entries):
            promptUserInput(prompt: prompt, command: command)
            outputDockerPs(
                command: command,
                entries: entries
            
            )
        
        case .error(let errorCommand, let message):
            promptUserInput(prompt: prompt, command: command)
            outputError(command: errorCommand, message: message)
        }
        
        if prompt {
            appendToHistory(command)
        }
        input = ""
    }
    
    func parseResult(_ result: String) -> CommandResult {
        guard
            let data = result.data(using: .utf8),
            let decoded = try? JSONDecoder()
                .decode(RustCommandResult.self, from: data)
        else {
            return .text(result)
        }

        
        switch decoded.kind {
        case .exit:
            return .exit
        case .clear:
            return .clear
        case .clearline:
            return .clearline
        case .text:
            return .text(decoded.text ?? "")
        
        case .gitStatus:
            return .gitStatus(
                branch: decoded.branch ?? "",
                branchStatus: decoded.branch_status ?? "",
                entries: decoded.git_status_entries ?? []
            )
            
        case .dockerPs:
            return .dockerPs(
                entries: decoded.docker_ps_entries ?? []
            )

        case .listing:
            return .listing(
                entries: decoded.entries ?? []
            )
            
        case .error:
            return .error(
                command: decoded.command ?? "",
                message: decoded.message ?? ""
            )
        }
    }
}
