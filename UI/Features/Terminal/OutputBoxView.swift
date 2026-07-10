//
//  TerminalSessionView.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI

struct OutputBox: View {
    var terminal: Terminal
    var history: TerminalHistory
    var autocomplete: TerminalAutocomplete

    @AppStorage("fontDesign") var selectedFont: FontPicker = .system

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    terminalTextOutput
                        .padding(.bottom, 75)
                        .id("bottom")
                }
                .contentMargins(16, for: .scrollContent)

                .onChange(of: terminal.output) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )

            TerminalTextbox(
                terminal: terminal,
                history: history,
                autocomplete: autocomplete
            )
        }
    }
}

extension OutputBox {
    var terminalTextOutput: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(terminal.output) { item in
                switch item.kind {
                case .text(let text):
                    Text("\(ANSIParser.attributedString(from: text))")
                
                case .error(let command, let message):
                    HStack(spacing: 6) {
                        Symbol(
                            "exclamationmark.triangle.fill",
                            render: .multicolor
                        )

                        Text("Error")
                            .foregroundStyle(.red)
                            .fontWeight(.semibold)

                        Text(command)
                            .foregroundStyle(.orange)
                            .fontWeight(.semibold)

                        Text(message)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .font(.system(
            size: 14,
            weight: .regular,
            design: selectedFont.design
        ))
        .lineSpacing(2)
        .textSelection(.enabled)
        
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
