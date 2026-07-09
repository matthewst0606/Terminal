//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @Bindable var workspace: TerminalWorkspace
    
    
    var body: some View {
        TabView(selection: $workspace.selectedTabID) {
            ForEach(workspace.tabs) { tab in
                TerminalScrollView(
                    terminal: tab.terminal,
                    history: tab.history,
                    prediction: tab.prediction
                )
                .tabItem() {
                    Text(tab.title)
                }
                .tag(tab.id)
            }
        }
        .modifier(
            NewTerminalTab(workspace: workspace)
        )
        
        .kbShortcut("w", modifier: .command) {
            workspace.closeTab(workspace.selectedTabID)
        }
    }
}

struct NewTerminalTab: ViewModifier {
    var workspace: TerminalWorkspace
    
    func body(content: Content) -> some View {
        content
        .toolbar {
            createNewTerminalTab
        }
    }
    
    private var createNewTerminalTab: some ToolbarContent {
        return ToolbarItem(placement: .principal) {
            AnimatedButton(.bouncy(duration: 0.3)) {
                workspace.createNewTab()
            }
            label: {
                Symbol(
                    name: "plus",
                    render: .monochrome,
                    gradient: .gradient
                )
            }
        }
    }
}
