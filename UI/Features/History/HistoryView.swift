//
//  HistoryView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI


struct HistoryView: View {
    var terminal: Terminal
    var history: TerminalHistory

    var body: some View {
        VStack {
            TerminalList(
                historyItem,
                .history,
            )
            .terminalListStyle(.regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
        .toolbar {
            addFolder
            removeFolder
        }
    }

    
    var historyItem: [ListElement] {
        terminal.history.map { command in
            ListElement(
                leadingText: command,
                leadingSymbol: "folder.fill",
                trailingSymbol: "bookmark"
            )
        }
    }
    
    var addFolder: some ToolbarContent {
        TerminalToolbarItem(
            placement: .secondaryAction,
            symbolName: "folder.fill.badge.plus"
        ) {}
    }
    
    var removeFolder: some ToolbarContent {
        TerminalToolbarItem(
            placement: .secondaryAction,
            symbolName: "folder.fill.badge.minus"
        ) {}
    }
}
