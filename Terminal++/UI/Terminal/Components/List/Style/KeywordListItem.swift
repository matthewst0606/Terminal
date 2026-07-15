//
//  KeywordListItem.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//

import SwiftUI
// ---------- formatting for a keyword list item ----------
struct KeywordsListItem: View {
    let item: ListElement
    var body: some View {
        HStack(spacing: 12) {
            Text(item.leadingText ?? "")
                .font(.system(size: 13, weight: .medium, design: .monospaced))
            Spacer()
            
            Text(item.trailingText ?? "")
                .font(.system(size: 13, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 7)
    }
}
