//
//  TerminalSessionView.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI

struct TerminalScrollView: View {
    var terminal: Terminal
    var history: TerminalHistory
    var prediction: PredictionService

    @AppStorage("fontDesign") var selectedFont: FontPicker = .system

    var body: some View {
        VStack(spacing: 0) {
            terminalScrollView.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .overlay(alignment: .bottom) {
                TerminalTextbox(
                    terminal: terminal,
                    history: history,
                    prediction: prediction
                )
            }
        }
    }
}

extension TerminalScrollView {
    var terminalScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                terminalTextOutput
                    .padding(.bottom, 100)
                    .id("bottom")
            }
            .onChange(of: terminal.output) {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }
    
    private var terminalTextOutput: some View {
        Text(terminal.output)
            .font(.system(
                size: 14,
                weight: .regular,
                design: selectedFont.design
        ))
        .neswPadding(5, 10, 5, 10)
        .textSelection(.enabled)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



