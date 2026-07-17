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
    let onCommand: () -> Void
    
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            Symbol(
                "clock",
                font: .system(size: 13),
                render: .hierarchical
            )
            .foregroundStyle(.secondary)

            Text(item.leadingText ?? "")
                .font(.system(size: 13, design: .monospaced))
            
            Spacer()
            
            Button {
                isFavorite.toggle()
            }
            label: {
                Symbol(
                    isFavorite ? "star.fill" : "star",
                    font: .system(size: 13),
                    render: .hierarchical
                )
                .foregroundStyle(.tertiary)
            }
            .buttonStyle(.plain)

        }
        .padding(.vertical, 7)
        Divider()


    }
    

}
