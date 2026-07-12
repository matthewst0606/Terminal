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
            switch selectedTab {
                case .terminal: BackgroundJobsView()
                case .keywords: KeywordOverlay(terminal: terminal)
                case .history: HistoryOverlay(terminal: terminal, history: history)
                case .themes: ThemesOverlay()
                case .newTab, .none: EmptyView()
            }
            
            HStack(spacing: 10) {
                OverlayButton(icon: "keyboard.macwindow", title: nil, isSelected: selectedTab == .keywords) {
                    selectedTab = .keywords
                }
                OverlayButton(icon: "clock.badge.checkmark.fill", title: nil, isSelected: selectedTab == .history) {
                    selectedTab = .history
                }
                OverlayButton(icon:  "slider.horizontal.3", title: nil, isSelected: selectedTab == .themes) {
                    selectedTab = .themes
                }
                OverlayButton(icon: "macwindow.badge.plus", title: nil, isSelected: selectedTab == .newTab) {
                    openWindow(id: "content-window")
                }
            }
        }
        .frame(
            minWidth: FrameLib.overlay.width,
            maxWidth: FrameLib.overlay.width
        )
        .glassRect(radius: FrameLib.overlay.cornerRadius)
        .padding(FrameLib.overlay.padding)
        .offset(y: -75)
    }
    
}

