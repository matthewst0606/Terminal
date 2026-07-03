//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                terminalTextOutput()
            }

            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )

            TerminalTextbox(terminal: terminal, history: history)
        }
    }
}


// =============
// -- helpers --
// =============
extension TerminalView {
    private func terminalTextOutput() -> some View {
        Text(terminal.output)
            .font(.system(
                size: 14,
                weight: .regular,
                design: .monospaced
            ))
            .neswPadding(5, 10, 5, 10)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}










