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

struct TerminalOverlayMenu: View {
    @Environment(\.openWindow) private var openWindow
    @Binding var selectedTab: SmallTabs

    var terminal: Terminal
    var history: TerminalHistory

    private let items = OverlayItem<SmallTabs>.terminalOverlayItems
    
    var body: some View {
        VStack {
            getTab
            
            HStack {
                overlayButtons
            }
        }
        .padding(20)
        .frame(width: 250)
        .glassRect(radius: 20, padding: 10)
        .offset(y: -80)
    }

    @ViewBuilder
    private var getTab: some View {
        if selectedTab != .none {
            switch selectedTab {
            case .terminal: TerminalOverlayView()
            case .keywords: KeywordOverlay()
            case .history:  HistoryOverlay(terminal: terminal, history: history)
            case .themes:   ThemesOverlay()
            case .newTab:   ThemesOverlay()
            case .none:     EmptyView()
            }
        }
    }
    
    private var overlayButtons: some View {
        ForEach(OverlayItem.terminalOverlayItems) { item in
            OverlayButton(item: item, isSelected: selectedTab == item.tab, style: .small) {

                
                if item.tab == .newTab {
                    openWindow(id: "content-window")
                } else {
                    selectedTab = selectedTab == item.tab ? .none : item.tab
                }
            }
            
            if item.id != items.last?.id {
                Divider()
            }
        }
    }
}

struct SmallOverlayView: ViewModifier {
    @State var toggleSmallOverlay: Bool = false
    @State var selectedSmallTab: SmallTabs = .none
    @Bindable var terminal: Terminal
    var history: TerminalHistory
    
    func body(content: Content) -> some View {
        content
        .overlay(alignment: .trailing) {
            textboxToggleButton
        }
        .background(alignment: .bottomTrailing) {
            displaySmallOverlay
        }
    }
    
    var textboxToggleButton: some View {
        TextBoxButtonView("ellipsis", isVisible: $toggleSmallOverlay)
    }
    
    
    
    @ViewBuilder
    var displaySmallOverlay: some View {
        if toggleSmallOverlay {
            SmallOverlay(
                selectedTab: $selectedSmallTab,
                terminal: terminal,
                history: history
            )
            .modifier(OverlayTransition(.bottom))
        }
    }
}


