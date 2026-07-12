//
//  HistoryService.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import Observation

@Observable
class TerminalHistory {
    private let terminal: Terminal
    private var historyIndex: Int?
    
    init(terminal: Terminal) {
        self.terminal = terminal
    }
    
    
    func resetIndex() {
        historyIndex = nil
    }
 
    func previousCommand() -> String? {
        guard !commands.isEmpty else { return nil }
        
        guard let i = historyIndex else {
            historyIndex = commands.count - 1
            return currentCommand
        }
        
        historyIndex = max(0, i - 1)
        return currentCommand
    }
    
    
    func nextCommand() -> String? {
        guard !commands.isEmpty else { return nil }

        guard let i = historyIndex else {
            historyIndex = commands.count + 1
            return currentCommand
        }
        
        historyIndex = min(commands.count - 1, i + 1)
        return currentCommand
    }
    
    
    private var commands: [String] {
        terminal.history
    }

    private var currentCommand: String? {
        guard let historyIndex else { return nil }
        return commands[historyIndex]
    }
}
