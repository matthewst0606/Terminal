//
//  HistoryView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI


struct HistoryView: View {
    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    @StateObject private var keywordsService = KeywordsService()


    var body: some View {
        VStack {




            TerminalList(
                items: history.historyItem(),
                style: .history,
            )
            .terminalListStyle(style: .regular)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                addFolder()
            }

            ToolbarItem(placement: .secondaryAction) {
                removeFolder()
            }
        }
    }
    
    private func addFolder() -> some View {
        return AnimatedButton(.bouncy(duration: 0.5)) {
            }
            label: {
                Symbol(
                    name: "folder.fill.badge.plus",
                    render: .monochrome,
                    gradient: .gradient
                    
                )
            }
    }
    
    
    private func removeFolder() -> some View {
        return AnimatedButton(.bouncy(duration: 0.5)) {
        }
        
        label: {
            Symbol(
                name: "folder.fill.badge.minus",
                render: .monochrome,
                gradient: .gradient
                
            )
        }
    }
}




