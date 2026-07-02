//
//  SmallDisplayMenu.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI


private extension OverlayMenuItem where Overlay == SmallTabs {
    static let smallItems: [OverlayMenuItem<SmallTabs>] = [
        OverlayMenuItem(image: "apple.terminal.fill", tab: SmallTabs.terminal),
        OverlayMenuItem(image: "keyboard.macwindow", tab: SmallTabs.keywords),
        OverlayMenuItem(image: "clock.badge.checkmark.fill", tab: SmallTabs.history),
        OverlayMenuItem(image: "slider.horizontal.3", tab: SmallTabs.themes),
        OverlayMenuItem(image: "macwindow.badge.plus", tab: SmallTabs.newTab)
    ]
}

struct SmallOverlay: View {
    @ObservedObject var terminal: TerminalService
    @Binding var selectedTab: SmallTabs

    private let items = OverlayMenuItem<SmallTabs>.smallItems
    
    
    var body: some View {
        VStack {
            getTab()

            HStack {
                ForEach(OverlayMenuItem.smallItems) { item in
                    DisplayButton(
                        item: item,
                        isSelected: selectedTab == item.tab,
                        style: .small
                    ) {
                        selectedTab = selectedTab == item.tab ? .none : item.tab
                    }
                    if item.id != items.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(20)
        .glassRect(radius: 20, padding: 20)
        .offset(y: -75)
    }
    
    @ViewBuilder
    private func getTab() -> some View {
        if selectedTab != .none {
            switch selectedTab {
            case .terminal: TerminalOverlay()
            case .keywords: KeywordOverlay()
            case .history:  HistoryOverlay(terminal: terminal)
            case .themes:   ThemesOverlay()
            case .newTab:   ThemesOverlay()
            case .none:     EmptyView()
            }
        }
    }
}
