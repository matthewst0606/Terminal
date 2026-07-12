//
//  TerminalKeyboardShortcuts.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
import SwiftUI

struct ShortcutsModifier: ViewModifier {
    let getPrevHistory: () -> Void
    let getNextHistory: () -> Void

    func body(content: Content) -> some View { content
        .kbShortcut(key: .upArrow) {
            getPrevHistory()
        }
        .kbShortcut(key: .downArrow) {
            getNextHistory()
        }
        .kbShortcut(key: "c", with: .control) {
            
        }
    }
}
