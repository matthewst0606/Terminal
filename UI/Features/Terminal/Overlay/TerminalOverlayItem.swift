//
//  OverlayMenuItem.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//

import Foundation
import SwiftUI

struct TerminalOverlayItem<Overlay: Hashable>: Identifiable {
    let id = UUID()
    let title: String?
    let image: String
    let tab: Overlay

    init(title: String? = nil, image: String, tab: Overlay) {
        self.title = title
        self.image = image
        self.tab = tab
    }
}

extension TerminalOverlayItem where Overlay == SidebarTabs {
    static let sidebarItems: [TerminalOverlayItem] = [
        TerminalOverlayItem(
            title:"Terminal++",
            image: "apple.terminal.fill",
            tab: SidebarTabs.terminal
        ),
        TerminalOverlayItem(
            title:"Keywords",
            image:"keyboard.macwindow",
            tab: SidebarTabs.keywords
        ),
        TerminalOverlayItem(
            title:"History",
            image:"clock.badge.checkmark.fill",
            tab: SidebarTabs.history
        ),
        TerminalOverlayItem(
            title:"Themes",
            image:"slider.horizontal.3",
            tab: SidebarTabs.themes
        )
    ]
}

extension TerminalOverlayItem where Overlay == SmallTabs {
    static let terminalOverlayItems: [TerminalOverlayItem<SmallTabs>] = [
        TerminalOverlayItem(
            image: "keyboard.macwindow",
            tab: SmallTabs.keywords
        ),
        TerminalOverlayItem(
            image: "clock.badge.checkmark.fill",
            tab: SmallTabs.history
        ),
        TerminalOverlayItem(
            image: "slider.horizontal.3", tab:
                SmallTabs.themes
        ),
        TerminalOverlayItem(
            image: "macwindow.badge.plus",
            tab: SmallTabs.newTab
        )
    ]
}
