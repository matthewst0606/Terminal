//
//  HistoryService.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import Foundation
import Combine

@MainActor
class HistoryService: ObservableObject {
    private let terminal: TerminalService
    private var i: Int?
    

    init(terminal: TerminalService) {
        self.terminal = terminal
    }
    
    
    static func testHistoryItem() -> [ListElement] {[
        ListElement(
            leadingText: "Docker",
            leadingSymbol: "folder.fill",
            trailingSymbol: "bookmark"
        ),
        ListElement(
            leadingText: "Git",
            leadingSymbol: "folder.fill",
            trailingSymbol: "bookmark"
        ),
    ]}
    
    
    func historyItem() -> [ListElement] {
        terminal.history.map { command in
            ListElement(
                leadingText: command,
                leadingSymbol: "folder.fill",
                trailingSymbol: "bookmark"
            )
        }
    }
    
    
    
    // get previous item from HistoryService
    func prevHistory() {
        guard let prev = getPrevIndex() else { return }
        DispatchQueue.main.async {
            self.terminal.input = prev
         }
    }
    
    // get next item from HistoryService
    func nextHistory() {
        guard let next = getNextIndex() else { return }
        DispatchQueue.main.async {
            self.terminal.input = next
         }
    }
    
    func killTerminal() {
        guard let next = getNextIndex() else { return }
        DispatchQueue.main.async {
            self.terminal.input = next
         }
    }
    
    func resetIndex() {
        i = nil
    }
    
    func getPrevIndex() -> String? {
        guard !terminal.history.isEmpty else { return nil }
        
        if i == nil { i = terminal.history.count - 1 }
        else { i = max(0, i! - 1) }
        
        return terminal.history[i!]
    }
    
    func getNextIndex() -> String? {
        guard !terminal.history.isEmpty else { return nil }
        
        if i == nil { i = terminal.history.count + 1 }
        else { i = min(terminal.history.count - 1, i! + 1) }
        
        return terminal.history[i!]
    }
    

    
}
