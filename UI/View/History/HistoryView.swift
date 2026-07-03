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
            HStack {
                pageButton(symbol: "folder.fill.badge.plus") {}
                pageButton(symbol: "folder.fill.badge.minus") {}
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .neswPadding(10, 20, 0, 20)


            TerminalList(
                items: history.historyItem(),
                style: .history
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
    }
}



extension HistoryView {    
    
    private func pageButton(
        _ title: String = "",
        symbol: String,
        action: @escaping () -> Void
        
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if !title.isEmpty {
                    Text(title)
                }
                Symbol(
                    name: symbol,
                    font: .system(size: 20),
                    render: .multicolor,
                    gradient: .gradient
                )
            }
            .neswPadding(5, 8, 5, 8)
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .glassRect()
        }
        .buttonStyle(.plain)
    }
}
