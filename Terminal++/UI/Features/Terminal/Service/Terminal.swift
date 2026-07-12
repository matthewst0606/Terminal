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
    var history: [String] = []
    var currentDir = ""
    
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
}



