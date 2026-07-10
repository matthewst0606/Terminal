//
//  OverlayButton.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import SwiftUI
import Foundation

struct OverlayView: View {
    @Environment(\.openWindow) private var openWindow
    @Binding var selectedTab: TerminalItem

    var terminal: Terminal
    var history: TerminalHistory

    private let items: [TerminalOverlayItem] = [
        TerminalOverlayItem(
            button: OverlayButtonItem(nil, "keyboard.macwindow"),
            action: .select(.keywords)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(nil, "clock.badge.checkmark.fill"),
            action: .select(.history)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(nil, "slider.horizontal.3"),
            action: .select(.themes)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(nil, "macwindow.badge.plus"),
            action: .openNewWindow
        )
    ]
    
    var body: some View {
        VStack {
            tabContent
            HStack { overlayButtons }
                .padding(12)
        }
        
        .glassRect(radius: 14)
        .padding(12)
        .frame(minWidth: 250, maxWidth: 250)
        .offset(y: -75)
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
            case .terminal: BackgroundJobsView()
            case .keywords: KeywordOverlay()
            case .history:  HistoryOverlay(terminal: terminal, history: history)
            case .themes:   ThemesOverlay()
            case .newTab:   EmptyView()
            case .none:     EmptyView()
        }
    }
    
    private var overlayButtons: some View {
        ForEach(items) { item in
            OverlayButton(
                item.button,
                isSelected(item),
                .small
            ) {
                select(item)
            }

            if item.id != items.last?.id {
                Divider().frame(height: 20)
            }
        }
    }
    
    private func select(_ item: TerminalOverlayItem) {
        switch item.action {
        case .select(let tab):
            selectedTab = selectedTab == tab ? .none : tab

        case .openNewWindow:
            openWindow(id: "content-window")
        }
    }

    private func isSelected(_ item: TerminalOverlayItem) -> Bool {
        switch item.action {
        case .select(let tab):
            return selectedTab == tab

        case .openNewWindow:
            return false
        }
    }
}


struct TerminalOverlayItem: Identifiable {
    let id = UUID()
    let button: OverlayButtonItem
    let action: TerminalOverlayAction
}

enum TerminalItem {
    case none
    case terminal
    case keywords
    case history
    case themes
    case newTab
}

enum TerminalOverlayAction {
    case select(TerminalItem)
    case openNewWindow
}


