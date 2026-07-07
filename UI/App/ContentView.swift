//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State var toggleSidebar: Bool = false
    @State private var isSelected: Bool = false
    @State private var isHovering: Bool = false
    @State private var sidebarTab: SidebarTabs = .terminal

    @State private var tabs: [TerminalTab]
    @State private var selectedTerminalTab: TerminalTab.ID
    
    init() {
        let firstTab = TerminalTab(title: "Terminal 1")
        _tabs = State(initialValue: [firstTab])
        _selectedTerminalTab = State(initialValue: firstTab.id)
    }
    
    
    var body: some View {
        VStack {
            getTab()
        }
        .toolbar {
            sidebarButton()
        }
        .overlay(alignment: .topTrailing) {
            displaySidebar()
        }

    }
}



extension ContentView {
    private func sidebarButton() -> some ToolbarContent {
        return ToolbarItem(placement: .primaryAction) {
            AnimatedButton(.bouncy(duration: 0.3)) {
                toggleSidebar.toggle()
            }
            label: {
                Symbol(
                    name: "sidebar.right",
                    render: .monochrome,
                    gradient: .gradient
                    
                )
            }
        }

    }
    @ViewBuilder
    private func displaySidebar() -> some View {
        if toggleSidebar {
            Sidebar(
                selectedTab: $sidebarTab,
                isHovering: $isHovering
            )
            .createTransition(
                from: Edge.trailing,
                with: AnyTransition.opacity
            )
        }
    }
    
    @ViewBuilder
    private func getTab() -> some View {
        switch sidebarTab {
        case .terminal:
            TerminalView(
                tabs: $tabs,
                selectedTerminalTab: $selectedTerminalTab
            )

        case .keywords: KeywordsView()
        case .history:
            if let tab = selectedTab {
                HistoryView(terminal: tab.terminal, history: tab.history)
            }
        case .themes:   ThemesView()
        }
    }

    private var selectedTab: TerminalTab? {
        tabs.first { $0.id == selectedTerminalTab } ?? tabs.first
    }
}
