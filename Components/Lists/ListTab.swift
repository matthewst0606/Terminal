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
        return VStack {
            HStack {
                Text(title)
                Symbol(
                    name: symbol,
                    font: .system(size: 24),
                    render: .hierarchical,
                )
            }
            .neswPadding(10, 0, 0, 0)

            
            Spacer()
            
            HStack {
                Text("alias")
                Spacer()
                Text("command")
            }
            .neswPadding(0, 40, 0, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)

            
    }
}
