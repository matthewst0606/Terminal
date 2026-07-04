//
//  TerminalList.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import SwiftUI


struct TerminalList: View {
    let items: [ListElement]
    let style: ListItemStyle

    var body: some View {
        List {
            ForEach(items) { item in
                ListItem(item: item, style: style)
                    .listSeparator()
            }
            .terminalListRow()
            .neswPadding(2, 5, 2, 5)
        }
        .terminalList()
        .frame(minWidth: 450, maxWidth: .infinity,
               minHeight: 450, maxHeight: .infinity)
        .bgRect(Color(NSColor.separatorColor).opacity(0.5))
        .bgRectBorder(.primary)
        .padding(20)
    }
}
