//
//  TerminalTabService.swift
//  Terminal++
//
//  Created by Matt on 7/6/26.
//

import Observation
import Foundation

@Observable
class TerminalTab: Identifiable {
    let id = UUID()
    let title: String
    let terminal: Terminal
    let history: TerminalHistory
    let prediction: PredictionService

    init(title: String) {
        let terminal = Terminal()
        let history = TerminalHistory(terminal: terminal)

        
        self.title = title
        self.terminal = terminal
        self.history = history
        self.prediction = PredictionService(
            terminal: terminal,
            history: history
        )
    }
}



