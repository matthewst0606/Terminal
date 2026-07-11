//
//  OverlayViewExtension.swift
//  Terminal++
//
//  Created by Matt on 7/11/26.
//
import SwiftUI

extension OverlayView {
    func terminalOverlayItems() -> [TerminalOverlayItem] {[
        TerminalOverlayItem(
            button: OverlayButtonItem(title: nil, icon: "keyboard.macwindow"),
            action: .select(.keywords)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(title: nil, icon: "clock.badge.checkmark.fill"),
            action: .select(.history)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(title: nil, icon: "slider.horizontal.3"),
            action: .select(.themes)
        ),
        TerminalOverlayItem(
            button: OverlayButtonItem(title: nil, icon: "macwindow.badge.plus"),
            action: .openNewWindow
        )
    ]}
    
    func select(_ item: TerminalOverlayItem) {
        switch item.action {
        case .select(let tab):
            selectedTab = selectedTab == tab ? .none : tab

        case .openNewWindow:
            openWindow(id: "content-window")
        }
        
    }

    func isSelected(_ item: TerminalOverlayItem) -> Bool {
        switch item.action {
        case .select(let tab):
            return selectedTab == tab

        case .openNewWindow:
            return false
        }
        
    }
    
    @ViewBuilder
    func lastItemDivider(_ item: TerminalOverlayItem) -> some View {
        if item.id != terminalOverlayItems().last?.id {
            Divider()
                .frame(height: 20)
        }
    }
}
