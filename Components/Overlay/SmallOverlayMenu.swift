//
//  SmallDisplayMenu.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI

enum SmallTabs {
    case none, terminal, keywords, history, themes, newTab
}



struct SmallOverlay: View {
    @Environment(\.openWindow) private var openWindow

    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    @Binding var selectedTab: SmallTabs

    private let items = OverlayItem<SmallTabs>.terminalOverlayItems
    
    var body: some View {
        VStack {
            getTab()
            HStack {
                ForEach(OverlayItem.terminalOverlayItems) { item in
                    OverlayButton(
                        item: item,
                        isSelected: selectedTab == item.tab,
                        style: .small
                    ) {
                        if item.tab == .newTab {
                            openWindow(id: "content-window")
                        }
                        else {
                            selectedTab = selectedTab == item.tab ? .none : item.tab
                        }
                    }
                    if item.id != items.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(10)
        .frame(width: 250)
        .glassRect(radius: 20, padding: 20)
        .offset(y: -75)
    }
}

private extension SmallOverlay {
    @ViewBuilder
    private func getTab() -> some View {
        if selectedTab != .none {
            switch selectedTab {
            case .terminal: EmptyView()
            case .keywords: KeywordOverlay()
            case .history:  HistoryOverlay(terminal: terminal, history: history)
            case .themes:   ThemesOverlay()
            case .newTab:   ThemesOverlay()
            case .none:     EmptyView()
            }
        }
    }
}


