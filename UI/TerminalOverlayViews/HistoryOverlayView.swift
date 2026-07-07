//
//  HistoryOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import SwiftUI

struct HistoryOverlay: View {
    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    
    
    var body: some View {
        HStack {
            TerminalList(
                items: history.historyItem(),
                style: .history,
            )

            .terminalListStyle(style: .overlay)

        }
        .frame(maxWidth: 250,
               maxHeight: 250,
               alignment: .top
        )
        .textSelection(.enabled)
    }
}
