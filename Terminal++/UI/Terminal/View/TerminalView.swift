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
        ZStack(alignment: .topLeading) {
            
            if let tab = workspace.selectedTab {
                OutputBox(
                    terminal: tab.terminal,
                    history: tab.history,
                    suggestion: tab.suggestion
                )
                .overlay(alignment: .top) {
                    ToolbarView(workspace: workspace)
                }
                .ignoresSafeArea(
                    .container,
                    edges: .top
                )
            }
        }
        .kbShortcut(key: "w", with: .command) {
            workspace.closeTab(workspace.id)
        }
    }
}



