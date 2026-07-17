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
    let onCommand: () -> Void

    
    var body: some View{
        switch style {
        case .keyword: KeywordsListItem(item: item)
        case .history: HistoryListItem(item: item, onCommand: onCommand)
        }
    }
}




