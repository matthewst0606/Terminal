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
        SidebarView($sidebarTab) {
            switch sidebarTab {
            case .terminal: terminalView
            case .keywords:
                if let tab = workspace.selectedTab {
                    KeywordsView(terminal: tab.terminal)
                }
            case .history:  historyView
            case .themes:   ThemesView()
            }
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



struct SidebarView<Content: View>: View {
    @Binding var selectedTab: SidebarTabs
    @State var isSidebarVisible = false
    private let content: Content

    init(_ selectedTab: Binding<SidebarTabs>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }

    
    var body: some View { content
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing) {
                TerminalControlButton(icon: "sidebar.right") {
                    isSidebarVisible.toggle()
                }

                if isSidebarVisible {
                    Sidebar($selectedTab).modifier(
                        OverlayTransition(.trailing)
                    )
                }
            }
            .padding(.top, 8)
            .padding(.trailing, 5)
            .ignoresSafeArea(
                .container,
                edges: .top
            )
        }
    }
}
