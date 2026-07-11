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
                OutputBox(tab.terminal, tab.history, tab.suggestion)
                    .overlay(alignment: .top) {
                        ToolbarView(workspace)
                    }
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
        .kbShortcut("w", modifier: .command) {
            workspace.closeTab(workspace.id)
        }
    }
}



struct ToolbarView: View {
    @Bindable var workspace: TerminalWorkspace
    @State var bgCommands: Bool = false

    init(_ workspace: TerminalWorkspace) {
        self.workspace = workspace
    }

    var body: some View {
        displayToolbar(content: Color.clear)
            .background(alignment: .topLeading) {
                if bgCommands {
                    BackgroundJobsView()
                        .modifier(OverlayTransition(.top))
                        .padding(.top, 35)
                        .padding(.leading, 10)
                }
            }
    }
    
    private func displayToolbar<Content: View>(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 30)
            .glassEffect(.regular, in: .rect)
            .overlay(alignment: .top) { toolbarTabs }
            .overlay(alignment: .topLeading) { toolbarButtons }
    }
    
    
    
    private var toolbarButtons: some View {
        HStack(spacing: 8) {
            TerminalControlButton(
                icon: "rectangle.stack.badge.play",
                isSelected: bgCommands,
                action: { bgCommands.toggle() }
            )
            
            TerminalControlButton(
                icon: "plus",
                action: { workspace.createNewTab() }
            )
        }
        
        .padding(.leading, 100)
        .padding(.top, 5)
    }
    
    private var toolbarTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(workspace.tabs) { tab in
                    TerminalTabButton(title: tab.title, isSelected: workspace.id == tab.id) {
                        workspace.id = tab.id
                    }
                    .frame(alignment: .center)
                }
            }
            .frame(maxWidth: .infinity,alignment: .center)
            
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(minWidth: 500, maxWidth: 500, alignment: .center)
        .glassEffect(.clear, in: .rect(cornerRadius: 10))
    }
}
