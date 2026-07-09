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
                formatListHeader(title, symbol)
                
                TerminalList(items: items, style: style)
                    .terminalListStyle(.regular)
            }
        }
        .tabItem {
            Text(title)
        }
    }
}

extension ListTab {
    private func formatListHeader(
        _ title: String,
        _ symbol: String
    ) -> some View {
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

            
            HStack {
                Text("alias")
                Spacer()
                Text("command")
            }
            .neswPadding(0, 40, 0, 40)
        }

    }
}
