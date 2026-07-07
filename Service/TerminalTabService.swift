//
//  TerminalTabService.swift
//  Terminal++
//
//  Created by Matt on 7/6/26.
//

import Foundation
import Combine

@MainActor
final class TerminalTab: ObservableObject, Identifiable {
    let id = UUID()
    let title: String

    let terminal: TerminalService
    let history: HistoryService

    init(title: String) {
        let terminal = TerminalService()
        self.title = title
        self.terminal = terminal
        self.history = HistoryService(terminal: terminal)
    }
}
