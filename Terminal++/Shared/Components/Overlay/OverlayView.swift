//
//  OverlayButton.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import SwiftUI
import Foundation

struct OverlayView: View {
    @Environment(\.openWindow) var openWindow
    @Binding var selectedTab: TerminalItem

    var terminal: Terminal
    var history: TerminalHistory
    
    var body: some View {
        VStack(spacing: 0) {
            tabContent
            overlayButtons
        }
        .frame(
            minWidth: FrameLib.overlay.width,
            maxWidth: FrameLib.overlay.width
        )
        .glassRect(radius: FrameLib.overlay.cornerRadius)
        .padding(FrameLib.overlay.padding)
        .offset(y: -75)
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .terminal: BackgroundJobsView()
        case .keywords: KeywordOverlay(terminal: terminal)
        case .history: HistoryOverlay(terminal: terminal, history: history)
        case .themes: ThemesOverlay()
        case .newTab, .none: EmptyView()
        }
    }
    
    private var overlayButtons: some View {
        HStack(spacing: 10) {
            ForEach(terminalOverlayItems()) { item in
                OverlayButton(
                    item.button,
                    isSelected(item),
                    action: {select(item)}
                )
            }
            .padding(8)
        }
    }
}


struct TerminalOverlayItem: Identifiable {
    let id = UUID()
    let button: OverlayButtonItem
    let action: TerminalOverlayAction
}

enum TerminalItem: Equatable {
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
