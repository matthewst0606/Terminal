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
            
            .terminalList()
            .frame(
                minWidth: 250,
                minHeight: 200,
            )

            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.55), radius: 24)
            .padding(10)
        }
        .frame(
            maxWidth: 300,
            maxHeight: 300,
            alignment: .topTrailing
        )
        
        .glassRect(radius: 24)
        .textSelection(.enabled)
    
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
