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
    let prompt: Prompt?

    struct Prompt: Equatable {
        let directory: String
        let command: String
    }

    enum Kind: Equatable {
        case text(String)
        case listing(entries: [DirectoryEntry])
        case gitStatus(
            branch: String,
            branchStatus: String,
            entries: [GitStatusEntry]
        )
        case gitAdd(
            added: Int,
            modified: Int,
            deleted: Int,
        
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
        _ = submitType(prompt: true)
    }

    @discardableResult
    func submitNoPrompt(_ command: String) -> Bool {
        input = command
        return submitType(prompt: false)
    }
    
    private func submitType(prompt: Bool) -> Bool {
        let command = input
        refreshDir()
        let promptSnapshot = prompt
            ? TerminalOutput.Prompt(directory: currentDir, command: command)
            : nil
        let result = parseResult(RustService.shared.execute(command))
        
        var success = true
        
        switch result {
        case .exit:
            exit()
            
        case .clear:
            clear()
            
        case .clearline:
            clearline()
            
        case .listing(let entries):
            outputList(
                command: command,
                entries: entries,
                prompt: promptSnapshot
            )
            
        case .text(let text):
            outputText(text, prompt: promptSnapshot)

        case .external(let stdout, let stderr, let exitCode):
            displayExternalOutput(
                command: command,
                stdout: stdout,
                stderr: stderr,
                exitCode: exitCode,
                prompt: promptSnapshot
            )
        
            
        case .gitStatus(let branch, let branchStatus, let entries):
            outputGitStatus(
                branch: branch,
                branchStatus: branchStatus,
                entries: entries,
                prompt: promptSnapshot
            )
            
        case .gitAdd(let added, let modified, let deleted):
            outputGitAdd(
                added: added,
                modified: modified,
                deleted: deleted,
                prompt: promptSnapshot
            )

        case .dockerPs(let entries):
            outputDockerPs(
                command: command,
                entries: entries,
                prompt: promptSnapshot
            )
        
        case .error(let errorCommand, let message):
            success = false
            outputError(
                command: errorCommand,
                message: message,
                prompt: promptSnapshot
            )
        }
        
        if prompt {
            appendToHistory(command)
        }
        input = ""
        return success
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

        case .external:
            return .external(
                stdout: decoded.stdout ?? "",
                stderr: decoded.stderr ?? "",
                exitCode: decoded.exit_code
            )
        
        case .gitStatus:
            return .gitStatus(
                branch: decoded.branch ?? "",
                branchStatus: decoded.branch_status ?? "",
                entries: decoded.git_status_entries ?? []
            )
            
        case .gitAdd:
            return .gitAdd(
                added: decoded.added ?? 0,
                modified: decoded.modified ?? 0,
                deleted: decoded.deleted ?? 0
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
