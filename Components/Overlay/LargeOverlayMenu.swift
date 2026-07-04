//
//  LargeOverlayMenu.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI

enum LargeTabs {
    case terminal, keywords, history, themes
}

struct LargeOverlay: View {
    @Binding var selectedTab: LargeTabs
    @Binding var isHovering: Bool
    var body: some View {
        VStack {
            ForEach(OverlayMenuItem.largeItems) { item in
                DisplayButton(item: item, isSelected: selectedTab == item.tab, style: .large) {
                    selectedTab = item.tab
                }
            }
        }
        .padding()
        .frame(maxWidth: 175, maxHeight: 250 , alignment: .topTrailing)
        .glassRect(radius: 24)
        .neswPadding(10, 10, 0, 0)
    }
}

private extension OverlayMenuItem where Overlay == LargeTabs {
    static let largeItems: [OverlayMenuItem] = [
        OverlayMenuItem(
            title:"Terminal++",
            image:"apple.terminal.fill",
            tab:LargeTabs.terminal
        ),
        OverlayMenuItem(
            title:"Keywords",
            image:"keyboard.macwindow",
            tab: LargeTabs.keywords
        ),
        OverlayMenuItem(
            title:"History",
            image:"clock.badge.checkmark.fill",
            tab: LargeTabs.history
        ),
        OverlayMenuItem(
            title:"Themes",
            image:"slider.horizontal.3",
            tab: LargeTabs.themes
        )
    ]
}

