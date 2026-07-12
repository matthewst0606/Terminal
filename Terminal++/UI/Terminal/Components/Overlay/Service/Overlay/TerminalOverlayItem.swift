//
//  TerminalOverlayItem.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI
enum TerminalOverlayAction {
    case select(TerminalItem)
    case openNewWindow
}


struct TerminalOverlayItem: Identifiable {
    let id = UUID()
    let button: OverlayButtonItem
    let action: TerminalOverlayAction
}

