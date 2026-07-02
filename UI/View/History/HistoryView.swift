//
//  HistoryView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI


struct HistoryView: View {
    @ObservedObject var terminal: TerminalService

    var body: some View {
        VStack {
            List {
                listItem("Github", symbol: "folder.fill", favoriteStatus: "bookmark.fill")
                listItem("Docker", symbol: "folder.fill")


                ForEach(Array(terminal.history.enumerated()), id: \.offset) { _, command in
                    Text(command)
                }
            }
            .padding(10)
            .terminalList()

            
            
            HStack {
                pageButton(symbol: "folder.fill.badge.plus") {}
                pageButton(symbol: "folder.fill.badge.minus") {}
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
        .neswPadding(5, 10, 5, 10)
    }
    
    private func listItem(
        _ title: String,
        symbol: String,
        favoriteStatus: String = "bookmark"
    ) -> some View {
        HStack {
            Symbol(
                name: symbol,
                render: .multicolor,
                gradient: .gradient,
            )
            Text(title)
            
            Spacer()
            
            Symbol(
                name: favoriteStatus,
                render: .multicolor,
                gradient: .gradient,
            )
        }
    }
    
    
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

