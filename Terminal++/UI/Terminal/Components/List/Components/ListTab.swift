//
//  ListTab.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

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
