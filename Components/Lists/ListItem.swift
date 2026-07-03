//
//  ListItem.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import SwiftUI


enum ListItemStyle {
    case keyword, history
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
        case .keyword:
            keywordStyle()
        case .history:
            historyStyle()
        }
    }
    
    func keywordStyle() -> some View {
        HStack {
            Text(item.leadingText!)
            Spacer()
            Text(item.trailingText!)
        }
    }
    
    func historyStyle() -> some View {
        HStack {
            Symbol(
                name: item.leadingSymbol!,
                render: .multicolor,
                gradient: .gradient,
            )
            Text(item.leadingText!)
            
            Spacer()
            
            Symbol(
                name: item.trailingSymbol!,
                render: .multicolor,
                gradient: .gradient,
            )
        }
        
    }
    
    func listSeparator() -> some View {
        self
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.06))
                .frame(height: 1)
                .offset(y:7)

        }
        .padding(2)
    }
}


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
