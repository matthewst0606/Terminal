//
//  HistoryListItem.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//
import SwiftUI
// ---------- formatting for a history list item ----------
struct HistoryListItem: View {
    let item: ListElement
    var body: some View {
        HStack(spacing: 10) {
            Symbol(item.leadingSymbol ?? "", font: .system(size: 13), render: .hierarchical)
                .foregroundStyle(.secondary)

            Text(item.leadingText ?? "")
                .font(.system(size: 13, design: .monospaced))
            
            Spacer()
            
            Symbol(item.trailingSymbol ?? "", font: .system(size: 13), render: .hierarchical,)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 7)
    }
}
