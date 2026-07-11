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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("History")
                    .font(.title3.weight(.semibold))
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)

            ListBody(
                items: historyItem,
                style: .history,
                terminal: terminal,
                executesOnTap: true
            )
            
            .terminalListStyle(.regular)
            
        }
        .applyFrame(.list)
        
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
                leadingSymbol: "clock",
                trailingSymbol: "bookmark"
            )
        }
    }
    
    var addFolder: some ToolbarContent {
        Toolbar(.secondaryAction, "folder.fill.badge.plus") {}
    }
    
    var removeFolder: some ToolbarContent {
        Toolbar(.secondaryAction, "folder.fill.badge.minus") {}
    }
}




struct HistoryOverlay: View {
    var terminal: Terminal
    var history: TerminalHistory

    var body: some View {
        HStack(content: {
            
            ListBody(
                items: historyItems,
                style: .history,
                terminal: terminal,
                executesOnTap: true
            )
            .terminalListStyle(.overlay)
        })
        .textSelection(.enabled)
    }

    var historyItems: [ListElement] {
        terminal.history.map { command in
            ListElement(
                leadingText: command,
                trailingSymbol: "bookmark"
            )
        }
    }
}
