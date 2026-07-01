//
//  SmallDisplayMenu.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI


struct SmallDisplayOverlay: View {
    @State var selectedOverlay: SmallOverlay = .none
    @Binding var output: String
    @Binding var history: [String]
    
    let items: [SmallMenuItem] = [
        SmallMenuItem(image:"apple.terminal.fill", overlay: .terminal),
        SmallMenuItem(image:"text.badge.plus", overlay: .keywords),
        SmallMenuItem(image:"clock.badge.checkmark.fill", overlay: .history),
        SmallMenuItem(image:"slider.horizontal.3", overlay: .themes),
    ]
    
    
    var body: some View {
        VStack {
            if selectedOverlay != .none { getTab() }

            HStack {
                ForEach(items) { item in
                    SmallDisplayButton(item: item) {
                        if selectedOverlay == item.overlay { selectedOverlay = .none }
                        else { selectedOverlay = item.overlay }
                    }
                    
                    
                    if item.id != items.last?.id { Divider() }
                }
            }
        }
        .padding(20)
        .glassRect(radius: 20, padding: 20)
        .offset(y: -75)
    }
    
    @ViewBuilder
    private func getTab() -> some View {
        switch selectedOverlay {
        case .terminal: TerminalOverlay()
        case .keywords: KeywordOverlay()
        case .history:  HistoryOverlay(history: $history)
        case .themes:   ThemesOverlay()
        default:        EmptyView()
            
        }
    }
}


enum SmallOverlay {
    case none,terminal, keywords, history, themes
}


struct SmallMenuItem: Identifiable {
    let id = UUID()
    let image: String
    let overlay: SmallOverlay
}


struct SmallDisplayButton: View {
    let item: SmallMenuItem
    let action: () -> Void
    var body: some View {
        VStack {
            Button { action() }
            label: {
                Symbol(
                    name: item.image,
                    font: .system(size: 20),
                    render: .multicolor,
                    gradient: .gradient
                )
            }
        }
        .background(.clear)
        .buttonStyle(.plain)
    }
}
