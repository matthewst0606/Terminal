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
    
    private var commands: [String] {
        terminal.history
    }


    private var currentCommand: String? {
        guard let historyIndex else { return nil }
        return commands[historyIndex]
    }
    
    func resetIndex() {
        historyIndex = nil
    }
    
    
    func mostRecentCommand(startingWith: String) -> String? {
        guard !commands.isEmpty else { return nil }

        let commandsReversed = commands.indices.reversed()
        
        
        for index in commandsReversed {
            if commands[index].starts(with: startingWith) {
                return commands[index]
            }
        }
        
        return nil
    }

 
    func previousCommand() -> String? {
        guard !commands.isEmpty else { return nil }
        
        if let i = historyIndex {
            historyIndex = max(0, i - 1)
        }
        else {
            historyIndex = commands.count - 1
        }
        
        return currentCommand
    }
    
    func nextCommand() -> String? {
        guard !commands.isEmpty else { return nil }

        if let i = historyIndex {
            historyIndex = min(commands.count - 1, i + 1)
        }
        else {
            historyIndex = commands.count + 1
        }
        
        return currentCommand
    }
    

    
}
