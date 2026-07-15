//
//  ViewExtension.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

extension View {
    
    func applyFrame(_ frame: FrameLib) -> some View {
        self.frame(
            width: frame.width,
            height: frame.height,
            alignment: frame.alignment ?? .center
        )
        .frame(
            minWidth: frame.minWidth,
            maxWidth: frame.maxWidth,
            minHeight: frame.minHeight,
            maxHeight: frame.maxHeight,
            alignment: frame.alignment ?? .center
        )
    }
    

    
    
    func shortcutsModifier(
        _ getPrevHistory: @escaping () -> Void,
        _ getNextHistory: @escaping () -> Void
    
    ) -> some View {
        self.modifier(
            ShortcutsModifier(
                getPrevHistory: getPrevHistory,
                getNextHistory: getNextHistory
            ))
    }
}




// ---------- rectangle formatting  ----------
extension View {
    func glassRect(
        _ glassColor: Glass = .regular,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
            .glassEffect(glassColor, in: .rect(cornerRadius: radius))
            .padding(padding)
    }
    
    func backgroundRect(
        _ color: Color,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
        .background(color, in: .rect(cornerRadius: radius))
        .padding(padding)
    }
    
    func bgRectBorder(
        _ color: Color = .secondary,
        opacity: CGFloat = 0.25,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.overlay {
            RoundedRectangle(cornerRadius: radius)
            .stroke(
                color.opacity(opacity),
                lineWidth: lineWidth
            )
        }
    }
}


// ---------- padding ----------
extension View {
    func neswPadding(
        _ north: CGFloat,
        _ east: CGFloat,
        _ south: CGFloat,
        _ west: CGFloat
    ) -> some View {
        self.padding(EdgeInsets(
            top: north,
            leading: west,
            bottom: south,
            trailing: east
        ))
    }
}


// ---------- List and list row formatting ----------
extension View {


        
    func listBodyStyle() -> some View {
        self
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .frame(
                minWidth: 250,
                minHeight: 200
            )
            .backgroundRect(
                ColorLib.panelStrong.color,
                radius: 24
            )
            .padding(10)
    }
    
    func toolbarContentTitle() -> some View {
        self
            .font(.title3.weight(.semibold))
            .padding(.horizontal, 18)
            .padding(.top, 16)
    }
    
    func toolbarContentBackground() -> some View {
        self
            .frame(
                maxWidth: 300,
                maxHeight: 300,
                alignment: .topTrailing
            )
            .glassRect(radius: 24)
    }
    
    func terminalList() -> some View {
        self
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
    }
    
    func listSeparator() -> some View {
        self
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(ColorLib.separator.color)
                .frame(height: 1)
                .offset(y: 7)
        }
        .padding(2)
    }
    
}


extension View {
    func kbShortcut(
        key: KeyEquivalent,
        with modifier: EventModifiers = [],
        _ action: @escaping () -> Void
    ) -> some View {
        self.background {
            Button("") { action() }
                .keyboardShortcut(key, modifiers: modifier)
                .hidden()
        }
        
    }
}


