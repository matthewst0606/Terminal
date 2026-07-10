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

struct ListElement: Identifiable {
    var id = UUID()
    var leadingText: String? = nil
    var trailingText: String? = nil
    var leadingSymbol: String? = nil
    var trailingSymbol: String? = nil
}

struct ListItem: View {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
           
            ListHeader(title: title,symbol: symbol)
            ListBody(items, style)
                .terminalListStyle(.regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
                Text(title)
                    .font(.title3.weight(.semibold))
                Symbol(
                    symbol,
                    font: .system(size: 18),
                    render: .hierarchical,
                )
                .foregroundStyle(.secondary)
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
}

// ----- list body formatting -----
struct ListBody: View {
    let items: [ListElement]
    let style: ListItemStyle

    init(_ items: [ListElement], _ style: ListItemStyle) {
        self.items = items
        self.style = style
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                ListItem(
                    item: item,
                    style: style
                )
                .listSeparator()
            }
            .terminalListRow()
            .neswPadding(2, 5, 2, 5)
        }
        .terminalList()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



// ---------- formatting for a keyword list item ----------
private struct KeywordsListItem: View {
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

// ---------- formatting for a history list item ----------
private struct HistoryListItem: View {
    let item: ListElement
    var body: some View {
        HStack(spacing: 10) {
            Symbol(
                item.leadingSymbol ?? "",
                font: .system(size: 13),
                render: .hierarchical,
            )
            .foregroundStyle(.secondary)

            Text(item.leadingText ?? "")
                .font(.system(size: 13, design: .monospaced))
            
            Spacer()
            
            Symbol(
                item.trailingSymbol ?? "",
                font: .system(size: 13),
                render: .hierarchical,
            )
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 7)
        
    }
}

// ---------- list seperator formatting between each row ----------
struct ListSeparator: ViewModifier {
    func body(content: Content) -> some View {
        content
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.primary.opacity(0.06))
                .frame(height: 1)
                .offset(y: 7)
        }
        .padding(2)
    }
}
