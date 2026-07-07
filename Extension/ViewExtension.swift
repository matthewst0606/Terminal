//
//  ViewExtension.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

// ---------- rectangle formatting  ----------
extension View {
    func glassRect(
        _ glassColor: Glass = .regular,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
            .glassEffect(
                glassColor,
                in: .rect(cornerRadius: radius)
            )
            .padding(padding)
    }
    
    func bgRect(
        _ color: Color,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
        .background(
            color,
            in: .rect(cornerRadius: radius)
        )
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
    func terminalList() -> some View {
        self
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
    }

    func terminalListRow() -> some View {
        self
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
    
}
// ---------- Animations ----------
extension View {
    func createTransition(
        from edge: Edge,
        with transition: AnyTransition
    ) -> some View {
        return self
            .transition(
                .move(edge: edge)
                .combined(with: transition)
            )
            .shadow(radius: 5)
    }
    
}


extension View {
    func kbShortcut(
        _ key: KeyEquivalent,
    modifier: EventModifiers = [],
        action: @escaping () -> Void
    ) -> some View {
        self.background {
            Button("") { action() }
                .keyboardShortcut(key, modifiers: modifier)
                .hidden()
        }
        
    }
}

extension View {
    func hoveringCursor() -> some View {
        self
        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()

            } else {
                NSCursor.pop()

            }
        }
    }
}

















