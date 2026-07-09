//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var sidebarTab: SidebarTabs = .terminal
    private var workspace = TerminalWorkspace()
    
    var body: some View {
        SidebarHost(selectedTab: $sidebarTab) {
            currentView
        }
    }
}

private extension ContentView {
    @ViewBuilder
    var currentView: some View {
        switch sidebarTab {
        case .terminal: terminalView
        case .keywords: KeywordsView()
        case .history:  historyView
        case .themes:   ThemesView()
        }
    }
    
    @ViewBuilder
    var historyView: some View {
        if let tab = workspace.selectedTab {
            HistoryView(
                terminal: tab.terminal,
                history: tab.history
            )
        }
    }
    
    var terminalView: some View {
        TerminalView(workspace: workspace)
    }
}
