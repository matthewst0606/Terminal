//
//  HistoryHelpers.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

extension HistoryView {
    func pageButton(
        _ title: String = "",
        symbol: String,
        action: @escaping () -> Void
        
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if !title.isEmpty { Text(title) }
                
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
