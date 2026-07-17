//
//  TerminalKeyboardShortcuts.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
import SwiftUI

struct KeyboardShortcutModifier: ViewModifier {
    let key: KeyEquivalent
    let modifiers: EventModifiers
    let action: () -> Void

    func body(content: Content) -> some View {
        content.background {
            Button("", action: action)
                .keyboardShortcut(key, modifiers: modifiers)
                .hidden()
        }
    }
}
