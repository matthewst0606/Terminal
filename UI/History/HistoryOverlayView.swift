//
//  HistoryOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import SwiftUI

//struct TerminalOverlay<Content: View>: View {
//    let content: Content
//    
//    
//    
//    var body: some View {
//        overlayFrame(overlayFor)
//    }
//    
//    private func overlayFrame(_ overlayFor: TerminalList) -> some View {
//        return HStack {
//            
//        }
//        .frame(
//            maxWidth: 250,
//            maxHeight: 250,
//            alignment: .top
//        )
//        .textSelection(.enabled)
//
//    }
//}

struct HistoryOverlay: View {
    var terminal: Terminal
    var history: TerminalHistory

    
    
    var body: some View {
        HStack {
            TerminalList(
                items: historyItem(),
                style: .history,
            )

            .terminalListStyle(.overlay)

        }
        .frame(
            maxWidth: 250,
            maxHeight: 250,
            alignment: .top
        )
        .textSelection(.enabled)
    }
}

extension HistoryOverlay {
    func historyItem() -> [ListElement] {
        terminal.history.map { command in
            ListElement(
                leadingText: command,
                trailingSymbol: "bookmark"
            )
        }
    }
}
