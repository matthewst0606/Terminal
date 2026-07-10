//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @Bindable var workspace: TerminalWorkspace
    @State var bgCommands: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading, content: {
            
            if let tab = workspace.selectedTab {
                OutputBox(
                    terminal: tab.terminal,
                    history: tab.history,
                    autocomplete: tab.autocomplete
                )
                .overlay(alignment: .top, content: {
                    terminalViewControls
                })
            }
            
            if bgCommands {
                BackgroundJobsView()
                    .modifier(OverlayTransition(.top))
                    .padding(.top, 20)
                    .padding(.leading, 10)
            }
            
        })
        .kbShortcut("w", modifier: .command) {
            workspace.closeTab(workspace.selectedTabID)
        }
    }
}
