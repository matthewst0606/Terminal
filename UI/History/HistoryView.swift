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
                items: historyItem,
                style: .history,
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
}

extension HistoryView {
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
        HistoryToolbarItem(
            placement: .secondaryAction,
            symbolName: "folder.fill.badge.plus"
        ) {}
    }
    
    var removeFolder: some ToolbarContent {
        HistoryToolbarItem(
            placement: .secondaryAction,
            symbolName: "folder.fill.badge.minus"
        ) {}
    }
}

struct HistoryToolbarItem: ToolbarContent {
    let placement: ToolbarItemPlacement
    let symbolName: String
    let action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            
            AnimatedButton(.bouncy(duration: 0.5)) { action() }
            label: {
                Symbol(name: symbolName)
            }
        }
    }
}
