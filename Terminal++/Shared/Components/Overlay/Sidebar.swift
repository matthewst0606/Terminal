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
        VStack(spacing: 6) {
            ForEach(SidebarItem.items) { item in
                OverlayButton(item.button, isSelected(item)) {
                    select(item)
                }
            }
        }
        .padding(FrameLib.sidebar.padding)
        .applyFrame(.sidebar)
        .glassRect(radius: FrameLib.sidebar.cornerRadius)
    }
    
    private func isSelected(_ item: SidebarItem) -> Bool {
        selectedTab == item.tab
    }

    private func select(_ item: SidebarItem) {
        selectedTab = item.tab
    }
}




struct SidebarItem: Identifiable {
    let id = UUID()
    let button: OverlayButtonItem
    let tab: SidebarTabs
}

extension SidebarItem {
    static let items: [SidebarItem] = [
        SidebarItem(
            button: OverlayButtonItem(title:"Terminal++", icon: "apple.terminal.fill"),
            tab: .terminal
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"Keywords", icon: "keyboard.macwindow"),
            tab: .keywords
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"History", icon: "clock.badge.checkmark.fill"),
            tab: .history
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"Themes", icon: "slider.horizontal.3"),
            tab: .themes
        )
    ]
}
