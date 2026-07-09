//
//  PredictionService.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import Observation


@Observable
final class PredictionService {
    let terminal: Terminal
    let history: TerminalHistory
   
    init(terminal: Terminal, history: TerminalHistory) {
        self.terminal = terminal
        self.history = history
    }
    
    
    func showPredictiveText() -> String? {
        guard !terminal.input.isEmpty,
              !terminal.history.isEmpty
        else { return nil }

        return history.mostRecentCommand(
            startingWith: terminal.input
        )
    }
}
