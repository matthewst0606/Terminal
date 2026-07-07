//
//  OverlayMenuItem.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//

import Foundation
import SwiftUI

struct OverlayItem<Overlay: Hashable>: Identifiable {
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

extension OverlayItem where Overlay == SidebarTabs {
    static let sidebarItems: [OverlayItem] = [
        OverlayItem(
            title:"Terminal++",
            image:"apple.terminal.fill",
            tab:SidebarTabs.terminal
        ),
        OverlayItem(
            title:"Keywords",
            image:"keyboard.macwindow",
            tab: SidebarTabs.keywords
        ),
        OverlayItem(
            title:"History",
            image:"clock.badge.checkmark.fill",
            tab: SidebarTabs.history
        ),
        OverlayItem(
            title:"Themes",
            image:"slider.horizontal.3",
            tab: SidebarTabs.themes
        )
    ]
}

extension OverlayItem where Overlay == SmallTabs {
    static let terminalOverlayItems: [OverlayItem<SmallTabs>] = [
        OverlayItem(
            image: "apple.terminal.fill",
            tab: SmallTabs.terminal
        ),
        OverlayItem(
            image: "keyboard.macwindow",
            tab: SmallTabs.keywords
        ),
        OverlayItem(
            image: "clock.badge.checkmark.fill",
            tab: SmallTabs.history
        ),
        OverlayItem(
            image: "slider.horizontal.3", tab:
                SmallTabs.themes
        ),
        OverlayItem(
            image: "macwindow.badge.plus",
            tab: SmallTabs.newTab
        )
    ]
}
