//
//  ToolbarView.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct ToolbarView: View {
    @Bindable var workspace: TerminalWorkspace
    @State private var selectedTab: TerminalItem = .none
    @State var bgCommands: Bool = false
    @Environment(\.openWindow) var openWindow

    private var terminal: Terminal? {
        workspace.selectedTab?.terminal
    }

    private var history: TerminalHistory? {
        workspace.selectedTab?.history
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
            .background(alignment: .topTrailing) {
                if selectedTab != .none {
                    tabContent
                        .modifier(OverlayTransition(.top))
                        .padding(.top, 35)
                        .padding(.trailing, 10)
                }
            }
    }

    
    private func displayToolbar<Content: View>(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 30)
            .glassEffect(.regular, in: .rect)
            .overlay(alignment: .top) {
                toolbarTabs
            }
            .overlay(alignment: .topLeading) {
                lhsToolbar
            }
            .overlay(alignment: .topTrailing) {
                rhsToolbar
            }
    }
    

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
            
        case .terminal:
            BackgroundJobsView()
            
        case .keywords:
            if let terminal {
                KeywordOverlay(terminal: terminal)
            }
            
        case .history:
            if let terminal, let history {
                HistoryOverlay(terminal: terminal, history: history)
            }
            
        case .themes:
            ThemesOverlay()
            
        case .newTab, .none:
            EmptyView()
        }
    }
    
    private var lhsToolbar: some View {
        HStack(spacing: 8) {
            ToolbarControlButton(icon: "rectangle.stack.badge.play", isSelected: bgCommands)
                { bgCommands.toggle() }
            
            ToolbarControlButton(icon: "plus")
                { workspace.createNewTab() }
        }
        .padding(.leading, 100)
    }
    
    private var rhsToolbar: some View {
        HStack(spacing: 8) {
            
            ToolbarControlButton(icon: "macwindow.badge.plus")
                { openWindow(id: "content-window") }
            
            ToolbarControlButton(icon: "keyboard.macwindow")
                { togglePanel(.keywords) }
            
            ToolbarControlButton(icon: "clock.badge.checkmark.fill")
                { togglePanel(.history) }
            
            ToolbarControlButton(icon: "slider.horizontal.3")
                { togglePanel(.themes) }
        }
        .padding(.trailing, 10)
    }

    private func togglePanel(_ panel: TerminalItem) {
        selectedTab = selectedTab == panel ? .none : panel
    }
    

    private var toolbarTabs: some View {
        HStack {
            Spacer()

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
        
        .clipShape(RoundedRectangle(
            cornerRadius: 10
        ))
        .frame(
            minWidth: 500,
            maxWidth: 500,
            alignment: .center
        )
    }
}
