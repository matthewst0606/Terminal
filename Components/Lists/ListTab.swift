//
//  ListTab.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import SwiftUI

struct ListTab: View {
    let title: String
    let symbol: String
    let items: [ListElement]
    let style: ListItemStyle
    
    var body: some View {
        HStack {
            VStack {
                formatListHeader(title, symbol: symbol)
                TerminalList(
                    items: items,
                    style: style
                )
            }
        }
        .tabItem {
            Text(title)
        }
    }
}

extension ListTab {
    private func formatListHeader(_ title: String, symbol: String) -> some View {
        return HStack {
            Text(title)
            Symbol(
                name: symbol,
                font: .system(size: 24),
                render: .hierarchical,
            )
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .neswPadding(10, 0, 0, 25)
    }
}
