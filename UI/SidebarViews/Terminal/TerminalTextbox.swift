//
//  TerminalTextbox.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//
import SwiftUI

struct TerminalTextbox: View {
    @State var toggleSmallOverlay: Bool = false
    @State var selectedSmallTab: SmallTabs = .none

    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    var body: some View {
        HStack {
            Textbox(placeholder: "Enter a command", text: $terminal.input) {
                terminal.submit()
                history.resetIndex()
            }
            .textboxStyle(.glass)
            .padding(8)
        }
        .overlay(alignment: .trailing) {
            textboxToggleButton()
        }
        .background(alignment: .bottomTrailing) {
            displaySmallOverlay()
        }
        .shadow(radius: 10)


        .kbShortcut(.upArrow, action: history.prevHistory)
        .kbShortcut(.downArrow, action: history.nextHistory)
        .kbShortcut("c", modifier: .control, action: history.killTerminal)
    }
}


