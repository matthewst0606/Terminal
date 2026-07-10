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
                OverlayButton(item.button, isSelected(item), .large) {
                    select(item)
                }
            }
        }
        .padding(8)
        .frame(width: 165, alignment: .topTrailing)
        .glassRect(radius: 14)
    }
    
    private func isSelected(_ item: SidebarItem) -> Bool {
        selectedTab == item.tab
    }

    private func select(_ item: SidebarItem) {
        selectedTab = item.tab
    }
}



struct SidebarHost<Content: View>: View {
    @Binding var selectedTab: SidebarTabs
    @State var isSidebarVisible = false
    private let content: Content

    init(
        _ selectedTab: Binding<SidebarTabs>,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self.content = content()
    }

    
    var body: some View { content
        .overlay(alignment: .topTrailing) {
            sidebar.ignoresSafeArea(
                .container,
                edges: .top
            )
        }
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
            button: OverlayButtonItem("Terminal++", "apple.terminal.fill"),
            tab: .terminal
        ),
        SidebarItem(
            button: OverlayButtonItem("Keywords", "keyboard.macwindow"),
            tab: .keywords
        ),
        SidebarItem(
            button: OverlayButtonItem("History", "clock.badge.checkmark.fill"),
            tab: .history
        ),
        SidebarItem(
            button: OverlayButtonItem("Themes", "slider.horizontal.3"),
            tab: .themes
        )
    ]
}


