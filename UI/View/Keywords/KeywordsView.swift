//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct KeywordsView: View {
    @AppStorage("keywords") private var input = ""
    @StateObject private var keywordsService = KeywordsService()
    
    var body: some View {
        VStack {
            VStack {
                formatListHeader("Default", symbol: "command.square.fill")
                formatList(action: keywordsService.defaultKeywords)
                    .neswPadding(10, 0, 10, 0)
            }
            .VStackFormat()

            VStack {
                formatListHeader("Custom", symbol: "keyboard.badge.ellipsis.fill")
                formatList(action: keywordsService.customKeywords)
                formatTextField("enter keyword")
            }
            .VStackFormat()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(NSColor.tertiarySystemFill))
        .textSelection(.enabled)
    }


    
    // =============
    // -- helpers --
    // =============
    private func formatListHeader(_ title: String, symbol: String) -> some View {
        return HStack {
            Text(title)
            Symbol(
                name: symbol,
                font: .system(size: 24),
                render: .palette
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .neswPadding(10, 0, 0, 25)
    }
    
    
    private func formatList(
        action: [KeywordItem]
    ) -> some View {
        return List {
            ForEach(action) { item in
                FormatKeywordItem(item: item)
                    .listSeparator()
            }
            .terminalListRow()
            .neswPadding(2, 5, 2, 5)
        }
        .terminalList()
        .frame(minWidth: 450 ,maxWidth: 600)
        .bgRect(Color(nsColor: .quaternarySystemFill), radius: 24)
        .neswPadding(0, 10, 0, 10)
    }
    
    private func formatTextField(_ title: String) -> some View {
        return TextField(title, text: $input)
            .onSubmit { }.textFieldStyle(.plain)
            .padding(10)
            .frame(minWidth: 450 ,maxWidth: 600)
            .bgRect(Color(nsColor: .quaternarySystemFill), radius: 10)
            .bgRectBorder(radius: 10)
            .neswPadding(25, 10, 10, 10)
    }
}




