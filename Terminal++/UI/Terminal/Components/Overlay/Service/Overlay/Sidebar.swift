//
//  Sidebar.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import SwiftUI

enum SidebarTabs {
    case terminal
    case keywords
    case history
    case themes
}

struct Sidebar: View {
    @Binding var selectedTab: SidebarTabs
    


    var body: some View {
        VStack(spacing: 6) {
            ForEach(SidebarItem.items) { item in
                OverlayButton(
                    icon: item.button.icon,
                    title: item.button.title,
                    isSelected: isSelected(item)
                ) {
                    select(item)
                }
            }
        }
        .padding(8)
        .frame(width: 150, alignment: .topTrailing)
        .glassRect(radius: 14)
    }
    
    private func isSelected(_ item: SidebarItem) -> Bool {
        selectedTab == item.tab
    }

    private func select(_ item: SidebarItem) {
        selectedTab = item.tab
    }
}


