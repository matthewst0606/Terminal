//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var toggleLargeOverlay: Bool = false
    @State private var isHovering: Bool = false
    @State private var selectedTab: OverlayTab = .terminal
    @State private var output: String = ""
    @State private var history: [String] = []

    
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .terminal: TerminalView(output: $output, history: $history)
            case .keywords: KeywordsView()
            case .history: HistoryView(history: $history)
            case .themes:   ThemesView()
            }
        }

        .overlay(alignment: .topTrailing) {
            if toggleLargeOverlay {
                LargeDisplayOverlay(selectedTab: $selectedTab, isHovering: $isHovering)
                    .createTransition(from: Edge.trailing, with: AnyTransition.opacity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                AnimatedButton(.bouncy(duration: 0.3)) {
                    toggleLargeOverlay.toggle()
                }
                label: {
                    Symbol(
                        name: "sidebar.right",
                        render: .multicolor,
                        gradient: .gradient
                    
                    )
                }
                
            }
        }
    }
}



enum OverlayTab {
    case terminal, keywords, history, themes
}

struct AnimatedButton<Label: View>: View {
    let animation: Animation
    let action: () -> Void
    let label: () -> Label
    
    init(
        _ animation: Animation = .bouncy(duration: 0.3),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.animation = animation
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button {
            withAnimation(animation) { action() }
        } label: {
            label()
        }
    }
}

struct LargeDisplayOverlay: View {
    @Binding var selectedTab: OverlayTab
    @Binding var isHovering: Bool


    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                
                ForEach(items) { item in
                    LargeDisplayButton(
                        item: item,
                        isSelected: selectedTab == item.tab) {
                            selectedTab = item.tab
                        }
                    if item.id != items.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: 175, maxHeight: 250 )
        .glassEffect(in:RoundedRectangle(cornerRadius: 24))
        .neswPadding(10, 10, 0, 0)
    }
    
    private let items: [OverlayMenuItem] = [
        OverlayMenuItem(
            title:"Terminal++",
            image:"apple.terminal.fill",
            tab: .terminal
        ),
        OverlayMenuItem(
            title:"Keywords",
            image:"keyboard.macwindow",
            tab: .keywords
        ),
        OverlayMenuItem(
            title:"History",
            image:"clock.badge.checkmark.fill",
            tab: .history
        ),
        OverlayMenuItem(
            title:"Themes",
            image:"slider.horizontal.3",
            tab: .themes
        )
    ]
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
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .neswPadding(5, 5, 5, 5)
        .background(
            backgroundColor,
            in: RoundedRectangle(cornerRadius: 16)
        )

        .scaleEffect(isHovering ? 1.08 : 1.0)
        .opacity(isHovering || isSelected ? 1.0 : 0.75)
        .onHover { hovering in
            withAnimation(.bouncy(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }

    private var backgroundColor: Color {
        switch true {
        case isSelected:  return Color.accentColor.opacity(0.75)
        case isHovering:  return Color.accentColor.opacity(0.35)
        default:          return Color.clear
            
        }
    }
}

