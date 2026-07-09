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

struct ListItem: View {
    let item: ListElement
    let style: ListItemStyle
    

    var body: some View{
        switch style {
        case .keyword: keywordStyle
        case .history: historyStyle
        }
    }

}

// ListItem styles
extension ListItem {
    private var keywordStyle: some View {
        HStack {
            Text(item.leadingText!)
            Spacer()
            Text(item.trailingText!)
        }
    }
    
    private var historyStyle: some View {
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
}

// ListItem formatting
struct ListSeparator: ViewModifier {
    func body(content: Content) -> some View {
        content
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.white.opacity(0.06))
                .frame(height: 1)
                .offset(y:7)
        }
        .padding(2)
    }
}

extension View {
    func listSeparator() -> some View {
        modifier(ListSeparator())
    }
}
