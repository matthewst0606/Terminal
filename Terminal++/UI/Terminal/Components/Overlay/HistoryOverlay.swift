//
//  HistoryView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI

struct HistoryOverlay: View {
    var terminal: Terminal
    var history: TerminalHistory


    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("History")
                .toolbarContentTitle()

            ListBody(
                items: historyItem,
                style: .history,
                terminal: terminal,
                executesOnTap: true
            )
            .listBodyStyle()
        }
        .toolbarContentBackground()
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
}
