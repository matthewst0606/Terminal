//
//  Sidebar.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import SwiftUI

enum SidebarTabs {
    case terminal, keywords, history, themes
}

struct Sidebar: View {
    @Binding var selectedTab: SidebarTabs

    init(_ selectedTab: Binding<SidebarTabs>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        VStack {
            ForEach(OverlayItem.sidebarItems) { item in
                OverlayButton(
                    item: item,
                    isSelected: selectedTab == item.tab,
                    style: .large
                ) {
                    selectedTab = item.tab
                }
            }
        }
        .padding()
        .frame(maxWidth: 175, maxHeight: 250 , alignment: .topTrailing)
        .glassRect(radius: 24)
        .neswPadding(10, 10, 0, 0)
    }
}
