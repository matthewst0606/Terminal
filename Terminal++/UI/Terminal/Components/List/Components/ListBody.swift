//
//  ListBody.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct ListBody: View {
    let items: [ListElement]
    let style: ListItemStyle
    let terminal: Terminal
    let executesOnTap: Bool

    
    var body: some View {
        List {
            ForEach(items) { item in
                
                
                if style == .history {
                    HistoryListItem(item: item, onCommand: {
                        terminal.submitNoPrompt(item.leadingText ?? "")
                    })
                }
                
                else {
                    Button {
                        let command = item.trailingText ?? ""
                        if executesOnTap {
                            terminal.submitNoPrompt(command)
                        } else {
                            terminal.input = command
                        }
                    }
                    label: {
                        ListContentView(
                            item: item,
                            style: style,
                            onCommand: {}
                        )
                        
                    }
                    .listSeparator()
                    .buttonStyle(.borderless)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .neswPadding(2, 5, 2, 5)
        }
        .terminalList()
        .clipShape(RoundedRectangle(
            cornerRadius: 12
        ))
    }
}
