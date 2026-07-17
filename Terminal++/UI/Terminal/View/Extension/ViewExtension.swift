//
//  ViewExtension.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI





// ---------- rectangle formatting  ----------
extension View {
    func glassRect(_ glass: Glass = .regular, radius: CGFloat = 10, padding: CGFloat = 0) -> some View {
        return self
            .glassEffect(glass, in: .rect(cornerRadius: radius))
            .padding(padding)
    }
    
    func backgroundRect(_ color: Color, radius: CGFloat = 10, padding: CGFloat = 0) -> some View {
        return self
        .background(color, in: .rect(cornerRadius: radius))
        .padding(padding)
    }
}


// ---------- padding ----------
extension View {
    func neswPadding(_ north: CGFloat, _ east: CGFloat, _ south: CGFloat, _ west: CGFloat) -> some View {
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
                minWidth: 400,
                minHeight: 250,
                maxHeight: .infinity
            )
            .background(.clear)
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
                maxWidth: 450,
                maxHeight: .infinity,
                alignment: .topTrailing
            )
            .glassRect(radius: 24, padding: 5)
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
                .fill(separator)
                .frame(height: 1)
                .offset(y: 7)
        }
        .padding(2)
    }
    
}

// ---------- shortcuts ----------


extension View {
    func kbShortcut(
        key: KeyEquivalent,
        with modifiers: EventModifiers = [],
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            KeyboardShortcutModifier(
                key: key,
                modifiers: modifiers,
                action: action
            )
        )
    }
}
