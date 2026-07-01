//
//  LargeOverlayMenu.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI

enum OverlayTab {
    case terminal, keywords, history, themes
}

struct OverlayMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let tab: OverlayTab
}

struct LargeDisplayButton: View {
    let item: OverlayMenuItem
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovering = false
    var body: some View {
        Button { action() } label: {
            HStack(spacing: 10) {
                Symbol(
                    name: item.image,
                    font: .system(size: 28),
                    render: .multicolor,
                    gradient: .gradient
                )
                .frame(width: 50, alignment: .center)
                
                
                Text(item.title)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .neswPadding(5, 5, 5, 5)
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .bgRect(backgroundColor, radius: 16)
            .scaleEffect(isHovering ? 1.08 : 1.0)
            .opacity(isHovering || isSelected ? 1.0 : 0.75)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.bouncy(duration: 0.2)) { isHovering = hovering }
        }
    }

    private var backgroundColor: Color {
        switch true {
        case isSelected:  return Color.accentColor.opacity(0.5)
        case isHovering:  return Color.accentColor.opacity(0.35)
        default:          return Color.clear
            
        }
    }
}

struct LargeDisplayOverlay: View {
    @Binding var selectedTab: OverlayTab
    @Binding var isHovering: Bool
    private let items: [OverlayMenuItem] = [
        OverlayMenuItem(title:"Terminal++", image:"apple.terminal.fill", tab: .terminal),
        OverlayMenuItem(title:"Keywords", image:"keyboard.macwindow", tab: .keywords),
        OverlayMenuItem(title:"History", image:"clock.badge.checkmark.fill", tab: .history),
        OverlayMenuItem(title:"Themes", image:"slider.horizontal.3", tab: .themes)
    ]
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                
                ForEach(items) { item in
                    LargeDisplayButton(item: item, isSelected: selectedTab == item.tab) {
                        selectedTab = item.tab
                    }
                    if item.id != items.last?.id { Divider() }
                }
            }
            .padding()
        }
        .frame(maxWidth: 175, maxHeight: 250 , alignment: .topTrailing)
        .glassRect(radius: 24)
        .neswPadding(10, 10, 0, 0)
    }
}
