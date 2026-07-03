//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State var toggleLargeOverlay: Bool = false
    @State private var isHovering: Bool = false
    @State private var selectedTab: LargeTabs = .terminal

    @StateObject private var terminal: TerminalService
    @StateObject private var history: HistoryService

    init() {
        let terminal = TerminalService()
        _terminal = StateObject(wrappedValue: terminal)
        _history = StateObject(wrappedValue: HistoryService(terminal: terminal))
    }
    var body: some View {
        VStack { getTab() }
            .toolbar { toolbarBtn() }
            .overlay(alignment: .topTrailing) { displayLargeOverlay() }
            .frame(alignment: .trailing)
    }
}




extension ContentView {
    @ViewBuilder
    private func displayLargeOverlay() -> some View {
        if toggleLargeOverlay {
            LargeOverlay(
                selectedTab: $selectedTab,
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

        switch selectedTab {
        case .terminal: TerminalView(terminal: terminal, history: history)
        case .keywords: KeywordsView()
        case .history: HistoryView(terminal: terminal, history: history)
        case .themes:   ThemesView()
        }
    }
    
    private func toolbarBtn() -> some ToolbarContent {
        return ToolbarItem(placement: .primaryAction) {
            AnimatedButton(.bouncy(duration: 0.3)) { toggleLargeOverlay.toggle() }
            label: {
                Symbol(
                    name: "sidebar.right",
                    render: .multicolor,
                    gradient: .gradient
                    
                )
            }
        }
    }
}
