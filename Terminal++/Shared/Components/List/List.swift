//
//  ListItem.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import SwiftUI

enum ListItemStyle {
    case keyword
    case history
}

struct ListContentView: View {
    let item: ListElement
    let style: ListItemStyle
    
    var body: some View{
        switch style {
        case .keyword: KeywordsListItem(item: item)
        case .history: HistoryListItem(item: item)
        }
    }
}

struct ListTab: View {
    let title: String
    let symbol: String
    let items: [ListElement]
    let style: ListItemStyle
    let terminal: Terminal
    let executesOnTap: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
           
            ListHeader(
                title: title,
                symbol: symbol
            )
            ListBody(
                items: items,
                style: style,
                terminal: terminal,
                executesOnTap: executesOnTap
            )
            .terminalListStyle(.regular)
        }
        .applyFrame(.overlayContent)
        .padding(.top, 16)
        .tabItem {
            Text(title)
        }
    }
}

// ----- list header formatting -----
struct ListHeader: View {
    let title: String
    let symbol: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                titleContent
                symbolContent
                Spacer()
            }
            .padding(.horizontal, 18)

            
            HStack {
                Text("alias")
                Spacer()
                Text("command")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .padding(.horizontal, 32)
        }
    }
    
    private var titleContent: some View {
        Text(title)
            .font(.title3.weight(.semibold))
    }
    
    private var symbolContent: some View {
        Symbol(symbol, font: .system(size: 18), render: .hierarchical)
            .foregroundStyle(.secondary)
    }
}

// ----- list body formatting -----
struct ListBody: View {
    let items: [ListElement]
    let style: ListItemStyle
    let terminal: Terminal
    let executesOnTap: Bool

    
    var body: some View {
        List {
            ForEach(items) { item in
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
                        style: style
                    )
                    
                }
                .listSeparator()
                .buttonStyle(.accessoryBar)
            }
            .terminalListRow()
            .neswPadding(2, 5, 2, 5)
        }
        .terminalList()
        .clipShape(RoundedRectangle(cornerRadius: FrameLib.list.cornerRadius))
    }
}
