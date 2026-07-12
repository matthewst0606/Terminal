//
//  SidebarItems.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct SidebarItem: Identifiable {
    let id = UUID()
    let button: OverlayButtonItem
    let tab: SidebarTabs

    static let items: [SidebarItem] = [
        SidebarItem(
            button: OverlayButtonItem(title:"Terminal++", icon: "apple.terminal.fill"),
            tab: .terminal
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"Keywords", icon: "keyboard.macwindow"),
            tab: .keywords
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"History", icon: "clock.badge.checkmark.fill"),
            tab: .history
        ),
        SidebarItem(
            button: OverlayButtonItem(title:"Themes", icon: "slider.horizontal.3"),
            tab: .themes
        )
    ]
}
