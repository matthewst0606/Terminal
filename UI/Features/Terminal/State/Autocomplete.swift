//
//  PredictionService.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import Observation

@Observable
final class TerminalAutocomplete {
    let terminal: Terminal
    let history: TerminalHistory
   
    init(terminal: Terminal, history: TerminalHistory) {
        self.terminal = terminal
        self.history = history
    }
    
    var predictionSuffix: String? {
        guard let
            suggestions = showPredictiveText(),
            suggestions.hasPrefix(terminal.input),
            suggestions != terminal.input
        else {
            return nil
        }
        
        return String(suggestions.dropFirst(terminal.input.count))
    }
    
    // --------------- helpers ---------------
    private var commands: [String] {
        terminal.history
    }
    
    private func showPredictiveText() -> String? {
        guard !terminal.input.isEmpty,
              !terminal.history.isEmpty
        else { return nil }

        return mostRecentCommand(
            startingWith: terminal.input
        )
    }

    private func mostRecentCommand(startingWith: String) -> String? {
        guard !commands.isEmpty else { return nil }
        
        for index in commands.indices.reversed() {
            if commands[index].starts(with: startingWith) {
                return commands[index]
            }
        }
        
        return nil
    }
}
